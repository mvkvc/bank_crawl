defmodule BankCrawl do
  use Application

  @dialyzer {:no_return, start: 2}
  @impl true
  def start(_type, _args) do
    children = [
      # {Canada, []}
    ]

    opts = [strategy: :one_for_one, name: BankCrawl.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
