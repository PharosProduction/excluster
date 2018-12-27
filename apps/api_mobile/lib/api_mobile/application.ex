defmodule ApiMobile.Application do
  @moduledoc false

  use Application

  alias ApiMobile.Metrics

  def start(_type, _args) do
    Metrics.Setup.setup()

    children = [
      ApiMobileWeb.Endpoint
      # {ApiMobile.Worker, arg},
    ]

    opts = [strategy: :one_for_one, name: ApiMobile.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    ApiMobileWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
