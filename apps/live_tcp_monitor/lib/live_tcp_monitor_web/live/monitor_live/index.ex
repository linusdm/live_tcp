defmodule LiveTcp.MonitorWeb.MonitorLive.Index do
  use LiveTcp.MonitorWeb, :live_view

  alias LiveTcp.Monitor

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    if connected?(socket), do: LiveTcp.MonitorWeb.Endpoint.subscribe("monitor:#{id}")
    value = Monitor.start_monitor(id)
    {:ok, assign(socket, value: value, id: id)}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_info({:new_value, value}, socket) do
    {:noreply, assign(socket, :value, value)}
  end
end
