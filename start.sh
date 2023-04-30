#! /bin/bash

if [ $# -gt 1 ]; then
    echo "Invalid number of arguments. Please specify 'CA', 'UK', 'US', or no argument for default (CA)."
    exit 1
fi

if [ $# -eq 0 ]; then
    MOD_ARG="CA"
else
    MOD_ARG=$1
fi

case "$MOD_ARG" in
"CA")
    MOD="BankCrawl.Spiders.CA"
    ;;
"UK")
    MOD="BankCrawl.Spiders.UK"
    ;;
"US")
    MOD="BankCrawl.Spiders.US"
    ;;
*)
    echo "Invalid argument. Please specify 'CA', 'UK', or 'US'."
    exit 1
    ;;
esac

echo "Starting spider for $MOD_ARG..."
iex -S mix run -e "Crawly.Engine.start_spider($MOD)"
