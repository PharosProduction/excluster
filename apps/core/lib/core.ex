defmodule Core do
  @moduledoc false

  def start_server do
    Horde.Supervisor.start_child(Core.ActionSupervisor, {Core.ActionServer, "John"})
  end

  def cast_server do
    Core.ActionServer.add("John", [1, 2])
  end

  def call_server do
    Core.ActionServer.contents("John")
  end

  def stop do
    :init.stop()
  end
end
