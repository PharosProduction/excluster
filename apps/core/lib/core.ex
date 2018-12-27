defmodule Core do
  @moduledoc "Documentation for Core."

  @doc """
  Hello world.

  ## Examples
      iex> Core.hello()
      "Hello from Core test config"
  """
  def hello, do: Application.get_env(:core, :demo_value)
end
