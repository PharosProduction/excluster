defmodule Core do
  @moduledoc false

  def start_server(id) do
    args = [id: id, arg1: "arg1", arg2: "arg2"]
    Horde.Supervisor.start_child(Core.ActionSupervisor, {Core.ActionServer, args})
    id
  end

  def read_server(id, param \\ nil), do: Core.ActionServer.read(id, param)

  def write_server(id, value), do: Core.ActionServer.write(id, value)

  def terminate_node, do: :init.stop()
end
