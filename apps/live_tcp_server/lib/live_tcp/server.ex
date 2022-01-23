defmodule LiveTcp.Server do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, Keyword.merge(opts, name: __MODULE__))
  end

  def init(_) do
    :ets.new(__MODULE__, [:named_table, :public, read_concurrency: true])

    {:ok, socket} =
      :gen_tcp.listen(4040, [:binary, packet: :line, active: false, reuseaddr: true])

    send(self(), :loop)
    {:ok, socket}
  end

  def handle_info(:loop, socket) do
    {:ok, client} = :gen_tcp.accept(socket)

    {:ok, pid} =
      Task.Supervisor.start_child(LiveTcp.Server.TaskSupervisor, fn ->
        serve(client)
      end)

    :gen_tcp.controlling_process(client, pid)
    send(self(), :loop)
    {:noreply, socket}
  end

  defp serve(socket) do
    {:ok, line} = :gen_tcp.recv(socket, 0)
    key = line |> String.replace("\r\n", "")

    value =
      case :ets.lookup(__MODULE__, key) do
        [{^key, value}] -> value
        [] -> "off"
      end

    :gen_tcp.send(socket, value)
    :gen_tcp.close(socket)
  end

  def set_value(key, new_value \\ "on") do
    :ets.insert(__MODULE__, {key, new_value})
  end
end
