defmodule Core.Application do
  @moduledoc false

  use Application

  require Logger

  # Public
  
  def start(_type, _args) do
    start_logger()
    join_world()
    start_service_discovery()

    children = [
      {Core.StateHandoff, []},
      {Horde.Registry, [name: Core.Registry, keys: :unique]},
      {Horde.Supervisor, [name: Core.ActionSupervisor, strategy: :one_for_one]},
      define_horde()
    ]
    opts = [strategy: :one_for_one, name: Core.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Private

  defp start_logger, do: :prometheus_httpd.start()

  defp join_world do
    with [_ | _] <- :net_adm.host_file() do
      :net_adm.world()
    else
      {:error, :enoent} -> Logger.error ".erlang.hosts not found"
    end
  end

  defp start_service_discovery, do: :nodefinder.multicast_start()

  defp define_horde do
    %{
      id: Core.HordeConnector,
      restart: :transient,
      start: {Task, :start_link, [fn ->
        Node.list()
        |> Enum.each(&join_node/1)
      end]}
    }
  end

  defp join_node(node) do
    Horde.Cluster.join_hordes(Core.ActionSupervisor, {Core.ActionSupervisor, node})
    Horde.Cluster.join_hordes(Core.Registry, {Core.Registry, node})
    :ok = Core.StateHandoff.join(node)
  end
end
