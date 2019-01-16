defmodule ApiMobile.Application do
  @moduledoc false

  require Logger

  alias ApiMobile.Metrics
  
  use Application

  # Callbacks
  
  @impl true
  def start(_type, _args) do
    start_logger()

    children = [
      ApiMobileWeb.Endpoint,
    ]
    opts = [strategy: :one_for_one, name: ApiMobile.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    ApiMobileWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  @impl true
  def prep_stop(state) do
    Logger.debug("PrepStop: #{inspect state}")
  end

  @impl true
  def stop(state) do
    Logger.debug("Stop: #{inspect state}")
  end

  # Private

  defp start_logger, do: Metrics.Setup.setup()
end
