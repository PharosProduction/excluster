defmodule ApiMobileWeb.DemoController do
  @moduledoc false

  use ApiMobileWeb, :controller

  ##### Public #####

  @spec demo(Plug.Conn.t(), map) :: Plug.Conn.t()
  def demo(%{assigns: %{version: :v1}} = conn, _params) do
    resp = Core.hello()

    render(conn, "v1.demo.json", demo: %{hello: resp})
  end

  @spec nodes(Plug.Conn.t(), map) :: Plug.Conn.t()
  def nodes(%{assigns: %{version: :v1}} = conn, _params) do
    resp = Core.node_list()

    render(conn, "v1.nodes.json", demo: resp)
  end

  @spec ping(Plug.Conn.t(), map) :: Plug.Conn.t()
  def ping(%{assigns: %{version: :v1}} = conn, %{"host" => host}) do
    resp = host
    |> String.to_atom
    |> Core.ping

    render(conn, "v1.ping.json", demo: resp)
  end

  @spec names(Plug.Conn.t(), map) :: Plug.Conn.t()
  def names(%{assigns: %{version: :v1}} = conn, _params) do
    resp = Core.names()

    render(conn, "v1.names.json", demo: resp)
  end
end
