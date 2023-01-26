defmodule Canada do
  def test_parse_item(url) do
    response = Crawly.fetch(url)
    {:ok, document} = Floki.parse_document(response.body)

    article_urls =
      document
      |> Floki.find("h3.media-heading")
      |> Floki.find("a")
      |> Floki.attribute("href")

    IO.puts(inspect(article_urls))

    next_page_url =
      document
      |> Floki.find("a.next.page-numbers")
      |> Floki.find("a")
      |> Floki.attribute("href")

    IO.puts(inspect(next_page_url))

    urls = article_urls ++ next_page_url

    IO.puts(inspect(urls))

    requests =
      Enum.map(urls, fn url ->
        url
        |> build_absolute_url("https://www.bankofcanada.ca/press/press-releases/")
        |> Crawly.Utils.request_from_url()
      end)

    IO.puts(inspect(requests))

    title =
      document
      |> Floki.find("title")
      |> Floki.text()
      |> String.trim_trailing(" - Bank of CanadaHome")

    IO.puts(title)

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

    IO.puts(text)
  end

  def build_absolute_url(url, request_url) do
    URI.merge(request_url, url)
    |> to_string()
  end
end
