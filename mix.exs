defmodule BankCrawl.MixProject do
  use Mix.Project

  @description "CLI to crawl central bank press releases."
  @source_url "https://github.com/mvkvc/bank_crawl"
  @version "0.1.0"

  def project do
    [
      app: :bank_crawl,
      name: "BankCrawl",
      description: @description,
      version: @version,
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      releases: releases(),
      docs: docs(),
      deps: deps(),
      aliases: aliases()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {BankCrawl, []}
    ]
  end

  def releases do
    [
      bank_crawl: [
        steps: [:assemble, &Burrito.wrap/1],
        burrito: [
          targets: [
            linux: [os: :linux, cpu: :x86_64]
            # macos: [os: :darwin, cpu: :x86_64],
            # windows: [os: :windows, cpu: :x86_64]
          ]
        ]
      ]
    ]
  end

  def docs do
    [
      extras: [
        {:"README.md", [title: "Overview"]}
      ],
      main: "readme",
      source_url: @source_url,
      source_ref: "v#{@version}"
    ]
  end

  defp deps do
    [
      {:httpoison, "~> 1.7"},
      {:burrito, github: "burrito-elixir/burrito"},
      {:crawly, "~> 0.15.0"},
      {:floki, "~> 0.34.0"},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.27", only: :dev, runtime: false}
    ]
  end

  defp aliases do
    [
      docs: ["docs --formatter html"]
    ]
  end
end
