defmodule Core do
  @moduledoc false

  alias Core.{
    ActionSupervisor,
    ActionServer,
    StoreServer
  }

  # Public

  def start_server(id) do
    args = [id: id, arg1: "arg1", arg2: "arg2"]
    Horde.Supervisor.start_child(ActionSupervisor, {ActionServer, args})
    id
  end

  def read_server(id, params \\ nil), do: ActionServer.read(id, params)

  def write_server(id, value), do: ActionServer.write(id, value)

  def pop_server(params \\ nil), do: StoreServer.pop(params)

  def pop_server_long(value \\ nil), do: StoreServer.pop_long(value)

  def push_server(value), do: StoreServer.push(value)

  def terminate_node, do: :init.stop()
end
