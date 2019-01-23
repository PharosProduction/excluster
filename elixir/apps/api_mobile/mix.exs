defmodule ApiMobile.MixProject do
  use Mix.Project

  def project do
    [
      app: :api_mobile,
      version: "1.0.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      deps: deps()
    ]
  end

  def application do
    [
      mod: {ApiMobile.Application, []},
      env: [],
      registered: [Excluster.ApiMobile],
      extra_applications: [
        :sasl,
        :logger,
        :runtime_tools,
        :observer,
        :wx
      ]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:phoenix, "~> 1.4"},
      {:phoenix_pubsub, "~> 1.1"},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.1"},
      {:plug_cowboy, "~> 2.0"},
      {:plug, "~> 1.7"},
      {:cowboy, "~> 2.6"},
      {:toml, "~> 0.5"},
      {:prometheus_ex, "~> 3.0"},
      {:prometheus_plugs, "~> 1.1"},
      {:elixir_uuid, "~> 1.2"},
      
      {:core, in_umbrella: true, only: [:dev, :test]}
    ]
  end
end
