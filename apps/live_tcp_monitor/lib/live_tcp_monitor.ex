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
    {:ok, _initial_value = "off"}
  end

  def handle_info(:poll, value) do
    {:ok, socket} = :gen_tcp.connect({127, 0, 0, 1}, 4040, [:binary, active: false])

    :gen_tcp.send(socket, "key\r\n")
    {:ok, new_value} = :gen_tcp.recv(socket, 0, :timer.seconds(1))
    :gen_tcp.close(socket)

    if new_value !== value, do: send(self(), :broadcast_change)

    Process.send_after(self(), :poll, :timer.seconds(10))
    {:noreply, new_value}
  end

  def handle_info(:broadcast_change, value) do
    IO.puts("sending mail")
    import Swoosh.Email

    new()
    |> to({"to", "to@example.com"})
    |> from({"from", "from@example.com"})
    |> subject("changed")
    |> html_body("<h1>new value: #{value}</h1>")
    |> text_body("new value: #{value}\n")
    |> LiveTcp.Monitor.Mailer.deliver()

    # Phoenix.PubSub.broadcast(LiveTcp.Monitor.PubSub, "alarm_value_changed", value)
    {:noreply, value}
  end
end
