defmodule BankCrawl.MixProject do
  use Mix.Project

  def project do
    [
      app: :bank_crawl,
      elixir: "~> 1.14",
      version: "0.1.0",
      start_permanent: Mix.env() == :prod,
      releases: releases(),
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {BankCrawl.Application, []}
    ]
  end

  def releases do
    [
      bank_crawl: [
        steps: [:assemble, &Burrito.wrap/1],
        burrito: [
          targets: [
            linux: [os: get_os_type(), cpu: :x86_64]
          ]
        ]
      ]
    ]
  end

  defp deps do
    [
      {:httpoison, "~> 1.7"},
      {:burrito, github: "burrito-elixir/burrito"},
      {:crawly, "~> 0.15.0"},
      {:floki, "~> 0.34.0"},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false}
    ]
  end

  def get_os_type do
    case :os.type() do
      {:unix, :darwin} -> :darwin
      {:unix, :linux} -> :linux
      {:win32, :nt} -> :windows
      _ -> :err
    end
  end
end
