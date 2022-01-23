defmodule LiveTcp.Server do
  use GenServer
  alias LiveTcp.Server

  def start_link(opts) do
    {:ok, _pid} = Server.Agent.start_link(:off)
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def init(_) do
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
    :gen_tcp.send(socket, "#{Atom.to_string(Server.Agent.get_value())}")
  end
end
