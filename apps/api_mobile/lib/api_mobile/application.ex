defmodule ApiMobile.Application do
  @moduledoc false

  use Application

  require Logger

  alias ApiMobile.Metrics

  def start(_type, _args) do
    start_logger()
    join_world()
    start_service_discovery()

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

  defp start_logger, do: Metrics.Setup.setup()

  defp join_world do
    with [_ | _] <- :net_adm.host_file() do
      :net_adm.world()
    else
      {:error, :enoent} -> Logger.error ".erlang.hosts not found"
    end
  end

  defp start_service_discovery, do: :nodefinder.multicast_start()
end
