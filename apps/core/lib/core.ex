defmodule Core do
  @moduledoc false

  @spec hostname :: {:ok, binary}
  def hostname do
    name = :inet.gethostname()
    |> Kernel.elem(1)
    |> List.to_string()

    {:ok, name}
  end

  @spec node_list :: {:ok, list(binary)}
  def node_list do
    {:ok, Node.list()}
  end

  @spec ping(atom) :: false | :ignored | true
  def ping(host) do
    Node.connect(host)
  end

  @spec names :: {:ok, map}
  def names do
    {:ok, names} = :net_adm.names()

    res = names
    |> Enum.into(fn el ->
      name = el
      |> elem(0)
      |> List.to_string()

      port = el
      |> elem(1)

      {name, port}
    end, %{})

    {:ok, res}
  end
end
