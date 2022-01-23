defmodule LiveTcp.Monitor do
  @moduledoc """
  LiveTcp.Monitor keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def init(_) do
    # allow server 5 seconds to startup
    Process.send_after(self(), :poll, :timer.seconds(5))
    {:ok, nil}
  end

  def handle_info(:poll, _state) do
    {:ok, socket} = :gen_tcp.connect({127, 0, 0, 1}, 4040, [:binary, active: false])
    {:ok, data} = :gen_tcp.recv(socket, 0)
    :gen_tcp.close(socket)
    Phoenix.PubSub.broadcast(LiveTcp.Monitor.PubSub, "alarm_value_changed", data)
    Process.send_after(self(), :poll, :timer.seconds(10))
    {:noreply, data}
  end

  def handle_call(:get_value, _from, data) do
    {:reply, data, data}
  end
end
