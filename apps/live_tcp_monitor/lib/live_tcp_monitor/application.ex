defmodule LiveTcp.Monitor.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      LiveTcp.Monitor.Repo,
      LiveTcp.MonitorWeb.Telemetry,
      {Phoenix.PubSub, name: LiveTcp.Monitor.PubSub},
      LiveTcp.MonitorWeb.Endpoint,
      LiveTcp.Monitor.Supervisor
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: LiveTcp.Monitor)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LiveTcp.MonitorWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
