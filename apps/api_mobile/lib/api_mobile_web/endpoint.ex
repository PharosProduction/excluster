defmodule ApiMobileWeb.Endpoint do
  @moduledoc false

  use Phoenix.Endpoint, otp_app: :api_mobile

  socket "/socket", ApiMobileWeb.UserSocket,
    websocket: true,
    longpoll: false

  if code_reloading? do
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head

  plug Plug.Session,
    store: :cookie,
    key: "_api_mobile_key",
    signing_salt: "0ry4cgBi"

  plug ApiMobileWeb.Router
end
