# bank_crawl

CLI to crawl central bank press releases.

Currently supported countries:

- [x] [Canada](https://www.bankofcanada.ca/press-releases/)
- [ ] [United Kingdom](https://www.bankofengland.co.uk/news/press-releases)
- [ ] [United States](https://www.federalreserve.gov/newsevents/pressreleases.htm)

## Requirements

Other than Elixir this project relies on the Burrito library to package the application into a single executable. Review the Burrito [requirements](https://github.com/burrito-elixir/burrito#preparation-and-requirements) to ensure you can build the executable.

## Setup

Your OS should be detected automatically, but if not, you can set it manually in the `mix.exs` file in the `releases` section.

```bash
mix deps.get
./sh/build.sh
```

## Usage

You can specify the country to crawl by space-separated country codes listed below, the default argument is `CA` if no argument is provided.

Example:

```bash
./sh/start.sh CA UK US
```
