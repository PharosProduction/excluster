defmodule Core do
  @moduledoc false

  def start_server(id \\ "id123") do
    args = [id: id, arg1: "arg1", arg2: "arg2"]
    Horde.Supervisor.start_child(Core.ActionSupervisor, {Core.ActionServer, args})
  end

  def read_server(param \\ nil, id \\ "id123"), do: Core.ActionServer.read(id, param)

  def write_server(value, id \\ "id123"), do: Core.ActionServer.write(id, value)

  def terminate_node, do: :init.stop()
end
