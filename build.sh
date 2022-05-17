set -e

mix credo
mix dialyzer
mix test
mix release