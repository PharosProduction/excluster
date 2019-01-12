defmodule ApiMobile.Cluster do

  @spec hostname :: {:ok, binary}
  def hostname do
    name = :inet.gethostname()
    |> Kernel.elem(1)
    |> List.to_string()

    {:ok, name}
  end
end