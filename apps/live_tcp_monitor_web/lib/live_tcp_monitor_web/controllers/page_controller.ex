defmodule LiveTcp.MonitorWeb.PageController do
  use LiveTcp.MonitorWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
