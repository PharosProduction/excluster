defmodule Core.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    :prometheus_httpd.start()

    IO.puts "LIST: #{inspect Node.list()}"
    start_task = {Task, :start_link, [fn ->
      Node.list()
      |> Enum.each(fn node ->
        res1 = Horde.Cluster.join_hordes(Core.ActionSupervisor, {Core.ActionSupervisor, node})
        IO.puts "RES1: #{inspect res1}"
        res2 = Horde.Cluster.join_hordes(Core.Registry, {Core.Registry, node})
        IO.puts "RES2: #{inspect res2}"
        :ok = Core.StateHandoff.join(node)
      end)
    end]}

    # {:ok, supervisor_1} = Horde.Supervisor.start_link([], name: :distributed_supervisor_1, strategy: :one_for_one)
    # {:ok, supervisor_2} = Horde.Supervisor.start_link([], name: :distributed_supervisor_2, strategy: :one_for_one)
    # {:ok, supervisor_3} = Horde.Supervisor.start_link([], name: :distributed_supervisor_3, strategy: :one_for_one)

    # Horde.Cluster.join_hordes(supervisor_1, supervisor_2)
    # Horde.Cluster.join_hordes(supervisor_2, supervisor_3)

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
