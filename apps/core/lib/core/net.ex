defmodule Core.Net do

  # Public

  def info do
    {:ok, host} = :inet.gethostname()
    {:ok, nodes} = :inet.getif()

    nodes_str = nodes
    |> Enum.map(&node_to_ip/1)

    {host, nodes_str}
  end

  # Private

  defp node_to_ip(node) do
    node
    |> elem(0)
    |> :inet_parse.ntoa
  end
end