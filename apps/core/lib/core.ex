defmodule Core do
  @moduledoc "Documentation for Core."

  @doc """
  Hello world.

  ## Examples
      iex> Core.hello()
      "Hello from Core test config"
  """
  def hello do
    {:ok, host} = :inet.gethostname() 

    host
    |> List.to_string
  end

  def node_list do
    Node.list()
  end

  def ping(host) do
    Node.ping(host)
  end

  def names do
    {:ok, names} = :net_adm.names()
    names
  end
end
