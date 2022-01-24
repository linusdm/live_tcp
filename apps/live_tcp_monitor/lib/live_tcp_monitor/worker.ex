defmodule LiveTcp.Monitor.Worker do
  use GenServer

  @registry LiveTcp.Monitor.Registry

  def start_link(id) do
    GenServer.start_link(__MODULE__, id, name: {:via, Registry, {@registry, id}})
  end

  def init(id) do
    send(self(), :poll)
    {:ok, {id, _initial_value = nil}}
  end

  def handle_info(:poll, {id, value}) do
    {:ok, socket} = :gen_tcp.connect({127, 0, 0, 1}, 4040, [:binary, active: false])

    :gen_tcp.send(socket, "#{id}\r\n")
    {:ok, new_value} = :gen_tcp.recv(socket, 0, :timer.seconds(1))
    :gen_tcp.close(socket)

    if new_value !== value, do: send(self(), :broadcast_change)

    Process.send_after(self(), :poll, :timer.seconds(10))
    {:noreply, {id, new_value}}
  end

  def handle_info(:broadcast_change, {id, value} = state) do
    import Swoosh.Email

    new()
    |> from({"from", "from@example.com"})
    |> to({"to", "to@example.com"})
    |> subject("changed")
    |> text_body("new value: #{value}\n")
    |> LiveTcp.Monitor.Mailer.deliver()

    Phoenix.PubSub.broadcast(LiveTcp.Monitor.PubSub, "alarm_value_changed:#{id}", value)
    {:noreply, state}
  end

  def handle_call(:get_value, _from, {_id, value} = state) do
    {:reply, value, state}
  end
end
