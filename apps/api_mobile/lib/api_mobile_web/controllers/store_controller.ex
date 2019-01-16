defmodule ApiMobileWeb.StoreController do
  @moduledoc false

  require Logger

  use ApiMobileWeb, :controller

  # Public

  def pop_server(%{assigns: %{version: :v1}} = conn, _params) do
    resp = Core.pop_server()

    send_resp(conn, :ok, inspect(%{data: resp}))
  end

  def push_server(%{assigns: %{version: :v1}} = conn, %{"value" => value}) do
    Core.push_server(value)

    send_resp(conn, :ok, "")
  end
end