defmodule ApiMobile.Metrics.Setup do
  @moduledoc "Module for Prometheus launch"

  alias ApiMobile.Metrics.MetricsExporter

  @doc "Start Prometheus. Should be called from Application start/2"
  def setup, do: MetricsExporter.setup()
end
