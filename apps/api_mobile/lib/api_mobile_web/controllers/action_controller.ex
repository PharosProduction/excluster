defmodule ApiMobileWeb.ActionController do
  @moduledoc false

  require Logger

  use ApiMobileWeb, :controller

  # Public
  
  def start_server(%{assigns: %{version: :v1}} = conn, _params) do
    id = UUID.uuid4()
    |> Core.start_server

    send_resp(conn, :ok, inspect(%{id: id}))
  end

  def read_server(%{assigns: %{version: :v1}} = conn, %{"id" => id}) do
    resp = Core.read_server(id)

    send_resp(conn, :ok, inspect(%{data: resp}))
  end

  def write_server(%{assigns: %{version: :v1}} = conn, %{"id" => id, "value" => value}) do
    Core.write_server(id, value)

    send_resp(conn, :ok, "")
  end

  def get_sys(%{assigns: %{version: :v1}} = conn, %{"id" => id}) do
    resp = Core.get_sys(id)

    send_resp(conn, :ok, inspect(%{data: resp}))
  end

  def stop_server(%{assigns: %{version: :v1}} = conn, %{"id" => id}) do
    Core.stop_server(id)
    
    send_resp(conn, :ok, "")
  end
end