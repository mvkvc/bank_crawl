defmodule Canada do
  use Crawly.Spider

  def start(), do: Crawly.Engine.start_spider(__MODULE__)

  @impl Crawly.Spider
  def base_url(), do: "https://www.bankofcanada.ca"

  @impl Crawly.Spider
  def init() do
    [
      start_urls: [
        "https://www.bankofcanada.ca/press/press-releases/"
      ]
    ]
  end

  @impl Crawly.Spider
  def parse_item(response) do
    {:ok, document} = Floki.parse_document(response.body)

    article_urls =
      document
      |> Floki.find("h3.media-heading")
      |> Floki.find("a")
      |> Floki.attribute("href")

    next_page_url =
      document
      |> Floki.find("a.next.page-numbers")
      |> Floki.find("a")
      |> Floki.attribute("href")

    urls = article_urls ++ next_page_url

    requests =
      Enum.map(urls, fn url ->
        url
        |> build_absolute_url("https://www.bankofcanada.ca/press/press-releases/")
        |> Crawly.Utils.request_from_url()
      end)

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
      cond do
        title == "Press Releases" ->
          ""

        check_post_content == "" ->
          document
          |> Floki.find("main")
          |> Floki.find("div.cfct-mod-content")
          |> Floki.find("p")
          |> Floki.text()

        true ->
          check_post_content
      end

    %Crawly.ParsedItem{
      :requests => requests,
      :items => [
        %{title: title, text: text, url: response.request_url}
      ]
    }
  end

  def build_absolute_url(url, request_url) do
    URI.merge(request_url, url)
    |> to_string()
  end
end
