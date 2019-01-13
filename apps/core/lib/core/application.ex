defmodule Core.Application do
  @moduledoc false

  use Application

  require Logger

  def start(_type, _args) do
    :prometheus_httpd.start()
    :nodefinder.multicast_start()

    with [_ | _] <- :net_adm.host_file() do
      :net_adm.world()
    else
      {:error, :enoent} -> Logger.error ".erlang.hosts not found"
    end

    start_task = {Task, :start_link, [fn ->
      Node.list()
      |> Enum.each(fn node ->
        Horde.Cluster.join_hordes(Core.ActionSupervisor, {Core.ActionSupervisor, node})
        Horde.Cluster.join_hordes(Core.Registry, {Core.Registry, node})
        :ok = Core.StateHandoff.join(node)
      end)
    end]}

    horde_connector = %{
      id: Core.HordeConnector,
      restart: :transient,
      start: start_task
    }

    children = [
      {Core.StateHandoff, []},
      {Horde.Registry, [name: Core.Registry, keys: :unique]},
      {Horde.Supervisor, [name: Core.ActionSupervisor, strategy: :one_for_one]},
      horde_connector
    ]
    opts = [strategy: :one_for_one, name: Core.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
