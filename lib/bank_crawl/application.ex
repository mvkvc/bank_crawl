defmodule BankCrawl.Application do
  use Application

  @impl true
  def start(_type, _args) do
    args = Burrito.Util.Args.get_arguments()

    spider_lookup = %{
      "CA" => BankCrawl.Spiders.CA,
      "US" => BankCrawl.Spiders.US,
      "UK" => BankCrawl.Spiders.UK
    }

    spiders =
      if length(args) == 0 do
        [BankCrawl.Spiders.CA]
      else
        Enum.reduce(args, [], fn id, acc ->
          value = Map.get(spider_lookup, id)
          if value, do: acc ++ [value], else: acc
        end)
      end

    children = []
    opts = [strategy: :one_for_one, name: BankCrawl.Supervisor]
    start_result = Supervisor.start_link(children, opts)

    # This is a hack, fix this so that each spider is supervised
    Enum.map(spiders, fn spider ->
      Crawly.Engine.start_spider(spider)
    end)

    start_result
  end
end
