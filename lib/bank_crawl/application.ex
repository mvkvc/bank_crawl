defmodule BankCrawl.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # {Crawly.Engine,
      #  [
      #    spiders: [
      #      BankCrawl.Spiders.CA,
      #      BankCrawl.Spiders.UK,
      #      BankCrawl.Spiders.US
      #    ]
      #  ]}
    ]

    opts = [strategy: :one_for_one, name: BankCrawl.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
