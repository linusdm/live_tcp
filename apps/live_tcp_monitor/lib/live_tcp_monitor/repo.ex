defmodule LiveTcp.Monitor.Repo do
  use Ecto.Repo,
    otp_app: :live_tcp_monitor,
    adapter: Ecto.Adapters.Postgres
end
