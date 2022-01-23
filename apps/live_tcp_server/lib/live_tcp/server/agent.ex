defmodule LiveTcp.Server.Agent do
  use Agent

  def start_link(initial_value) do
    Agent.start_link(fn -> initial_value end, name: :alarm_agent)
  end

  def toggle() do
    Agent.update(:alarm_agent, fn previous_value ->
      if previous_value == :on, do: :off, else: :on
    end)
  end

  def get_value(), do: Agent.get(:alarm_agent, fn value -> value end)
end
