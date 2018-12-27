defmodule Excluster.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),

      # Test
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      dialyzer: [plt_add_deps: :transitive],

      # Docs
      name: "Excluster",
      version: "1.0.0",
      source_url: "https://github.com/PharosProduction/excluster",
      homepage_url: "http://www.pharosproduction.com",
      docs: [
        logo: "./images/excluster_logo.svg",
        output: "./docs",
        extras: ["README.md", "ENVIRONMENT.md"]
      ]
    ]
  end

  defp deps do
    [
      {:distillery, github: "PharosProduction/distillery", runtime: false},
      {:ex_doc, "~> 0.19", only: [:dev], runtime: false},
      {:poison, "~> 4.0", only: [:test], override: true},
      {:excoveralls, "~> 0.10", only: [:test]},
      {:dialyxir, "~> 1.0.0-rc.4", only: [:dev, :test], runtime: false},
      {:credo, "~> 1.0", only: [:dev, :test], runtime: false}
    ]
  end

  # mix deps.clean mime --build
  # mix format
  # mix docs
  # mix test
  # mix dialyzer
  # mix credo
  # MIX_ENV=test mix cover
  # mix xref unreachable
  # mix xref deprecated
  defp aliases do
    [
      credo: ["credo --strict"],
      cover: ["coveralls -u -v"]
    ]
  end
end
