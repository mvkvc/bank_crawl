defmodule BankCrawl.Spider do
  use GenServer, restart: :transient

  @spider_lookup %{
    "CA" => BankCrawl.Spiders.CA,
    "US" => BankCrawl.Spiders.US,
    "UK" => BankCrawl.Spiders.UK
  }

  def start_link(spider_name) do
    GenServer.start_link(__MODULE__, spider_name, name: __MODULE__)
  end

  def init(spider_name) do
    send(self(), {:start_spider, spider_name})
    {:ok, %{}}
  end

  def handle_info({:start_spider, spider_name}, state) do
    spider = Map.get(@spider_lookup, spider_name, nil)

    if !spider do
      {:stop, :normal, state, :spider_not_found}
    else
      Crawly.Engine.start_spider(spider)
      {:noreply, state}
    end
  end
end
