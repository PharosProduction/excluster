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

    get "/start", ActionController, :start_server
    get "/read", ActionController, :read_server
    post "/write", ActionController, :write_server
    post "/stop", ActionController, :stop_server

    get "/hostname", ClusterController, :hostname
    get "/nodes", ClusterController, :nodes
    post "/ping", ClusterController, :ping
    get "/names", ClusterController, :names
  end

  defp handle_errors(%Plug.Conn{status: status} = conn, %{kind: _, reason: _, stack: _}) when status in [406, 500] do
    Logger.log(:info, fn ->
      %{
        "log_type" => "error",
        "request_params" => conn.params,
        "request_id" => Logger.metadata()[:request_id]
      }
      |> Jason.encode!
    end)

    send_resp(conn, status, "")
  end

  defp handle_errors(conn, _), do: conn
end
