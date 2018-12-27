defmodule ApiMobileWeb.DemoController do
  @moduledoc false

  use ApiMobileWeb, :controller

  ##### Public #####

  @spec show(Plug.Conn.t(), map) :: Plug.Conn.t()
  def show(%{assigns: %{version: :v1}} = conn, _params) do
    resp = Core.hello()

    render(conn, "v1.show.json", demo: %{hello: resp})
  end
end
