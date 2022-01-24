defmodule LiveTcp.Monitor do
  @moduledoc """
  LiveTcp.Monitor keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  @worker LiveTcp.Monitor.Worker
  @registry LiveTcp.Monitor.Registry
  @supervisor LiveTcp.Monitor.WorkerSupervisor

  def start_monitor(id) do
    pid =
      case Registry.lookup(@registry, id) do
        [{pid, _}] ->
          pid

        [] ->
          case DynamicSupervisor.start_child(@supervisor, {@worker, id}) do
            {:ok, pid} -> pid
            {:error, {:already_started, pid}} -> pid
          end
      end

    GenServer.call(pid, :get_value)
  end
end
