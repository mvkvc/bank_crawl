import Config

{_, cwd} = File.cwd()
folder = cwd <> "/data"

config :crawly,
  middlewares: [
    Crawly.Middlewares.UniqueRequest,
    {Crawly.Middlewares.UserAgent, user_agents: ["Crawly Bot"]}
  ],
  pipelines: [
    {Crawly.Pipelines.CSVEncoder, fields: [:title, :text]},
    {Crawly.Pipelines.WriteToFile, folder: folder, extension: "csv"}
  ]

# config :floki, :html_parser, Floki.HTMLParser.FastHtml
# config :floki, :html_parser, Floki.HTMLParser.Html5ever
