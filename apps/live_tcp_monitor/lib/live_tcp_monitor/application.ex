defmodule LiveTcp.Monitor.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      LiveTcp.Monitor.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: LiveTcp.Monitor.PubSub}
      # Start a worker by calling: LiveTcp.Monitor.Worker.start_link(arg)
      # {LiveTcp.Monitor.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: LiveTcp.Monitor.Supervisor)
  end
end
