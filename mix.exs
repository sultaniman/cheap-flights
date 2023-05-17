defmodule CheapFlights.MixProject do
  use Mix.Project

  def project do
    [
      app: :cheap_flights,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
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
      {:sweet_xml, "~> 0.7.3"},
      {:typed_struct, "~> 0.3.0"},
    ]
  end
end
