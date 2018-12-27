defmodule ApiMobileWeb.Router do
  @moduledoc false

  use ApiMobileWeb, :router

  if Mix.env() == :dev, do: use(Plug.Debugger)
  use Plug.ErrorHandler

  alias ApiMobileWeb.Plug.ApiVersion

  require Logger

  pipeline :api do
    plug :accepts, [:v1]
    plug ApiVersion
    plug :put_resp_content_type, MIME.type("json")
  end

  scope "/api", ApiMobileWeb do
    pipe_through :api

    get "/demo", DemoController, :demo
    get "/nodes", DemoController, :nodes
    post "/ping", DemoController, :ping
    get "/names", DemoController, :names
  end

  defp handle_errors(%Plug.Conn{status: status} = conn, %{
         kind: _kind,
         reason: _reason,
         stack: _stack
       })
       when status in [406, 500] do
    Logger.log(:info, fn ->
      Jason.encode!(%{
        "log_type" => "error",
        "request_params" => conn.params,
        "request_id" => Logger.metadata()[:request_id]
      })
    end)

    send_resp(conn, status, "")
  end

  defp handle_errors(conn, _), do: conn
end
