defmodule LiveTcp.Server.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Task.Supervisor, name: LiveTcp.Server.TaskSupervisor},
      LiveTcp.Server
    ]

    opts = [strategy: :one_for_one, name: LiveTcp.Server.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
