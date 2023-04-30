defmodule BankCrawl.Canada do
  use Crawly.Spider

  # @test_url "https://www.bankofcanada.ca/press/press-releases/"
  # @test_url "https://www.bankofcanada.ca/2023/04/deputy-governor-paul-beaudry-leave-bank-canada/"

  @impl Crawly.Spider
  def base_url(), do: "https://www.bankofcanada.ca/press/press-releases/"

  @impl Crawly.Spider
  def init() do
    [start_urls: ["https://www.bankofcanada.ca/press/press-releases/"]]
  end

  # def test do
  #   @test_url
  #   |> HTTPoison.get!()
  #   |> parse_item()
  # end

  @impl Crawly.Spider
  def parse_item(response) do
    {:ok, document} = Floki.parse_document(response.body)

    title =
      document
      |> Floki.find("title")
      |> Floki.text()
      |> String.trim_trailing(" - Bank of CanadaHome")

    check_post_content =
      document
      |> Floki.find("span.post-content")
      |> Floki.text()

    text =
      if check_post_content == "" do
        document
        |> Floki.find("main")
        |> Floki.find("div.cfct-mod-content")
        |> Floki.find("p")
        |> Floki.text()
      else
        check_post_content
      end

    items = [
      %{
        title: title,
        text: text,
        url: response.request_url
      }
    ]

    extracted_items = [] ++ items

    next_page_url =
      document
      |> Floki.find("a.next.page-numbers")
      |> Floki.find("a")
      |> Floki.attribute("href")

    next_requests =
      document
      |> Floki.find("h3.media-heading")
      |> Floki.find("a")
      |> Floki.attribute("href")

    urls =
      (next_page_url ++ next_requests)
      |> Enum.filter(fn x -> String.contains?(x, "https://www.bankofcanada.ca") end)

    requests =
      Enum.map(urls, fn url ->
        url
        |> build_absolute_url()
        |> Crawly.Utils.request_from_url()
      end)

    next_requests = [] ++ requests
    %Crawly.ParsedItem{items: extracted_items, requests: next_requests}
  end

  defp build_absolute_url(url), do: URI.merge(base_url(), url) |> to_string()
end
