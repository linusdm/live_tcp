defmodule LiveTcp.Monitor.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      LiveTcp.Monitor.Repo,
      {Phoenix.PubSub, name: LiveTcp.Monitor.PubSub},
      LiveTcp.Monitor
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: LiveTcp.Monitor.Supervisor)
  end
end
