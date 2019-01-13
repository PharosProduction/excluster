defmodule ApiMobileWeb.ActionController do
  @moduledoc false

  use ApiMobileWeb, :controller

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

  def stop_server(%{assigns: %{version: :v1}} = conn, _params) do
    Core.stop()
    
    send_resp(conn, :ok, "")
  end
end