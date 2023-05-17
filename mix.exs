defmodule CheapFlights.MixProject do
  use Mix.Project

  def project do
    [
      app: :cheap_flights,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      preferred_cli_env: [
        vcr: :test,
        "vcr.delete": :test,
        "vcr.check": :test,
        "vcr.show": :test
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {CheapFlights.Application, []}
    ]
  end

  defp deps do
    [
      {:quantum, "~> 3.0"},
      {:tesla, "~> 1.7"},
      {:hackney, "~> 1.18"},
      {:castore, "~> 1.0"},
      {:sweet_xml, "~> 0.7.3"},
      {:typed_struct, "~> 0.3.0"},
      {:plug_cowboy, "~> 2.6"},
      {:jason, "~> 1.4"},
      {:exvcr, "~> 0.14.1", only: :test}
    ]
  end
end
