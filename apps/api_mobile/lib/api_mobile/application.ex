defmodule ApiMobile.Application do
  @moduledoc false

  use Application

  require Logger

  alias ApiMobile.Metrics

  # Public
  
  def start(_type, _args) do
    start_logger()

    children = [
      ApiMobileWeb.Endpoint,
    ]
    opts = [strategy: :one_for_one, name: ApiMobile.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    ApiMobileWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  # Private

  defp start_logger, do: Metrics.Setup.setup()
end
