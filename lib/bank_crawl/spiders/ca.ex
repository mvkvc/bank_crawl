defmodule BankCrawl.Spiders.CA do
  use Crawly.Spider
  import BankCrawl.Utils

  @impl Crawly.Spider
  def base_url(), do: "https://www.bankofcanada.ca/press/press-releases/"

  @impl Crawly.Spider
  def init() do
    [start_urls: [base_url()]]
  end

  def test(url) do
    # Get request using HTTPoison
    response = HTTPoison.get!(url)
    parse_item(response)
  end

  @impl Crawly.Spider
  def parse_item(response) do
    {:ok, document} = Floki.parse_document(response.body)

    title =
      document
      |> Floki.find("h1.post-heading")
      |> Floki.text()

    date =
      document
      |> Floki.find("div.post-date")
      |> Floki.text()

    authors =
      document
      |> Floki.find("div.post-authors")
      |> Floki.text()

    content =
      document
      |> Floki.find("span.post-content")
      |> Floki.find("p")
      |> Floki.text()

    content =
      if content == nil or content == "" do
        document
        |> Floki.find("div.cfct-mod-content")
        |> Floki.find("p")
        |> Floki.text()
      else
        content
      end

    content =
      if content do
        content
        |> String.trim()
        |> String.replace("\n", "")
      else
        content
      end

    # content |> IO.inspect(label: "Content")

    item = %{
      url: response.request_url,
      title: title,
      date: date,
      authors: authors,
      content: content
    }

    # Pipeline check giving errors
    extracted_item = if not_missing?(item, [:url, :title, :date, :content]), do: [item], else: []

    new_page_url =
      document
      |> Floki.find("a.page-numbers")
      |> Floki.attribute("href")

    next_page_url =
      document
      |> Floki.find("a.next.page-numbers")
      |> Floki.attribute("href")

    next_requests =
      document
      |> Floki.find("h3.media-heading")
      |> Floki.find("a")
      |> Floki.attribute("href")

    removed_urls =
      ["publications", "multimedia", "wp-content", "banknotes"]
      |> Enum.map(fn url -> "https://www.bankofcanada.ca/" <> url end)

    next_requests =
      (new_page_url ++ next_page_url ++ next_requests)
      |> Enum.map(&build_absolute_url/1)
      |> Enum.filter(fn url -> !String.contains?(url, removed_urls) end)
      |> Enum.map(&Crawly.Utils.request_from_url/1)

    item = %Crawly.ParsedItem{items: extracted_item, requests: next_requests}
  end

  defp build_absolute_url(url), do: URI.merge(base_url(), url) |> to_string()
end
