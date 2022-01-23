defmodule LiveTcp.MonitorWeb.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      LiveTcp.MonitorWeb.Telemetry,
      # Start the Endpoint (http/https)
      LiveTcp.MonitorWeb.Endpoint
      # Start a worker by calling: LiveTcp.MonitorWeb.Worker.start_link(arg)
      # {LiveTcp.MonitorWeb.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LiveTcp.MonitorWeb.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LiveTcp.MonitorWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
