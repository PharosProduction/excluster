defmodule Core.Counters do

  # Public

  def get_counter(type) when type in [:read, :write] do
    with {:ok, count} <- Horde.Registry.meta(Core.Registry, type) do
      count
    else
      :error -> set_counter(0, type)
    end
  end

  def inc_counter(type) when type in [:read, :write] do
    type
    |> get_counter
    |> Kernel.+(1)
    |> set_counter(type)
  end

  # Private

  defp set_counter(value, type) when type in [:read, :write] do
    :ok = Horde.Registry.put_meta(Core.Registry, type, value)
    value
  end
end