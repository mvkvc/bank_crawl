import Config

{_, cwd} = File.cwd()
folder = cwd <> "/data"

config :floki, :html_parser, Floki.HTMLParser.Html5ever

config :crawly,
  middlewares: [
    Crawly.Middlewares.UniqueRequest,
    {Crawly.Middlewares.UserAgent, user_agents: ["Crawly Bot"]}
  ],
  pipelines: [
    {Crawly.Pipelines.CSVEncoder, fields: [:title, :text]},
    {Crawly.Pipelines.WriteToFile, folder: folder, extension: "csv"}
  ]
