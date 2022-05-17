defmodule CrawlCb.MixProject do
  use Mix.Project

  def project do
    [
      app: :crawl_cb,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {CrawlCb.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:burrito, github: "burrito-elixir/burrito"},
      {:crawly, "~> 0.13.0"},
      {:floki, "~> 0.26.0"},
      {:fast_html, "~> 2.0"},
      {:html5ever, "~> 0.9.0"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end

  def releases do
    [
      example_cli_app: [
        steps: [:assemble, &Burrito.wrap/1],
        burrito: [
          targets: [
            macos: [os: :darwin, cpu: :x86_64],
            linux: [os: :linux, cpu: :x86_64],
            windows: [os: :windows, cpu: :x86_64]
          ]
        ]
      ]
    ]
  end
end
