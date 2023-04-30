defmodule BankCrawl.Application do
  use Application

  @allowed_args ["CA", "UK", "US"]
  @csv_folder "data/"

  @impl true
  def start(_type, _args) do
    args =
      Burrito.Util.Args.get_arguments()
      |> Enum.uniq()
      |> Enum.filter(fn arg -> Enum.member?(@allowed_args, arg) end)

    spiders = if length(args) == 0, do: ["CA"], else: args

    IO.inspect(spiders, label: "spiders")

    children =
      spiders
      |> Enum.map(fn spider ->
        Supervisor.child_spec({BankCrawl.Spider, spider}, id: String.to_atom(spider))
      end)

    # Need to ensure that it stops after spiders end
    # |> Enum.concat([{BankCrawl.CSVWatcher, @csv_folder}])

    opts = [strategy: :one_for_one, name: BankCrawl.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
