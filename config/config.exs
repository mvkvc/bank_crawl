import Config

config :crawly,
  concurrent_requests_per_domain: 8,
  middlewares: [
    Crawly.Middlewares.DomainFilter,
    Crawly.Middlewares.UniqueRequest,
    {Crawly.Middlewares.UserAgent, user_agents: ["Crawly Bot", "Google"]}
  ],
  pipelines: [
    {Crawly.Pipelines.Validate, fields: [:url]},
    # {Crawly.Pipelines.Validate, fields: [:url, :title, :date, :authors, :content]},
    # Pipeline check giving errors
    # {BankCrawl.Pipelines.NotEmpty, fields: [:url, :title, :date, :content]},

    {Crawly.Pipelines.DuplicatesFilter, item_id: :url},
    {Crawly.Pipelines.CSVEncoder, fields: [:url, :title, :date, :authors, :content]},
    {Crawly.Pipelines.WriteToFile, extension: "csv", folder: File.cwd!() <> "/data"}
  ]
