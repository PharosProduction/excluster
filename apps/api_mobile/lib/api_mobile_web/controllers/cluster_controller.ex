defmodule ApiMobileWeb.ClusterController do
  @moduledoc false

  use ApiMobileWeb, :controller

  alias ApiMobile.Cluster

  # Public

  def start_server(%{assigns: %{version: :v1}} = conn, _params) do
    Core.start_server()

    send_resp(conn, :ok, "")
  end

  def cast_server(%{assigns: %{version: :v1}} = conn, _params) do
    Core.cast_server()

    send_resp(conn, :ok, "")
  end

  def call_server(%{assigns: %{version: :v1}} = conn, _params) do
    Core.call_server()
    
    send_resp(conn, :ok, "")
  end

  @spec hostname(Plug.Conn.t(), map) :: Plug.Conn.t()
  def hostname(%{assigns: %{version: :v1}} = conn, _params) do
    {:ok, host_api} = Cluster.hostname()
    {:ok, host_core} = Core.hostname()

    render(conn, "v1.hostname.json", cluster: %{host_api: host_api, host_core: host_core})
  end

  @spec nodes(Plug.Conn.t(), map) :: Plug.Conn.t()
  def nodes(%{assigns: %{version: :v1}} = conn, _params) do
    {:ok, nodes} = Core.node_list()

    render(conn, "v1.nodes.json", cluster: nodes)
  end

  @spec ping(Plug.Conn.t(), map) :: Plug.Conn.t()
  def ping(%{assigns: %{version: :v1}} = conn, %{"host" => host}) do
    resp =
      host
      |> String.to_atom()
      |> Core.ping()

    render(conn, "v1.ping.json", cluster: resp)
  end

  @spec names(Plug.Conn.t(), map) :: Plug.Conn.t()
  def names(%{assigns: %{version: :v1}} = conn, _params) do
    {:ok, names} = Core.names()

    render(conn, "v1.names.json", cluster: names)
  end
end
