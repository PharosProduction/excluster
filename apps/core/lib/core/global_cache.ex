defmodule Core.GlobalCache do
  
  # Attrs
  
  @registry Core.Registry

  # Public

  def get(type), do: Horde.Registry.meta(@registry, type)

  def put(type, value), do: Horde.Registry.put_meta(@registry, type, value)
end