defmodule ApiMobileWeb do
  @moduledoc false

  def controller do
    quote do
      use Phoenix.Controller, namespace: ApiMobileWeb

      import Plug.Conn
      import ApiMobileWeb.Gettext

      alias ApiMobileWeb.Router.Helpers, as: Routes
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/api_mobile_web/templates",
        namespace: ApiMobileWeb

      import Phoenix.Controller, only: [get_flash: 1, get_flash: 2, view_module: 1]
      import ApiMobileWeb.ErrorHelpers
      import ApiMobileWeb.Gettext

      alias ApiMobileWeb.Router.Helpers, as: Routes
    end
  end

  def router do
    quote do
      use Phoenix.Router

      import Plug.Conn
      import Phoenix.Controller
    end
  end

  def channel do
    quote do
      use Phoenix.Channel

      import ApiMobileWeb.Gettext
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
