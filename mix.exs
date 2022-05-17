defmodule BankCrawl.MixProject do
  use Mix.Project

  def project do
    [
      app: :bank_crawl,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      releases: releases()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {BankCrawl, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:burrito, github: "burrito-elixir/burrito"},
      {:crawly, "~> 0.13.0"},
      {:floki, "~> 0.26.0"},
      {:html5ever, "~> 0.13.0"}
    ]
  end

  def releases do
    [
      bank_crawl: [
        steps: [:assemble, &Burrito.wrap/1],
        burrito: [
          targets: [
            linux: [os: :linux, cpu: :x86_64]
          ],
        ]
      ]
    ]
  end
end
