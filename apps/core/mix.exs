defmodule Core.MixProject do
  use Mix.Project

  def project do
    [
      app: :core,
      version: "1.0.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.7",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      dialyzer: [
        plt_add_deps: :transitive,
        plt_apps: [:erts, :kernel, :stdlib],
        flags: [
          "-Wunmatched_returns",
          "-Werror_handling",
          "-Wrace_conditions",
          "-Wunderspecs",
          "-Wno_opaque"
        ]
      ],
      deps: deps()
    ]
  end

  def application do
    [
      mod: {Core.Application, []},
      registered: [Excluster.Core],
      env: [],
      extra_applications: [
        :sasl,
        :logger,
        :runtime_tools,
        :observer,
        :wx
      ]
    ]
  end

  defp deps do
    [
      {:horde, "~> 0.4.0-rc.2"},
      {:nodefinder, github: "PharosProduction/nodefinder"},
      {:nebulex, "~> 1.0"},
      {:pobox, "~> 1.2"},
      {:toml, "~> 0.5"},
      {:prometheus, "~> 4.2", override: true},
      {:prometheus_ex, "~> 3.0"},
      {:prometheus_plugs, "~> 1.1"},
      {:prometheus_httpd, "~> 2.1"}
    ]
  end
end
