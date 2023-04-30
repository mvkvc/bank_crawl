#! /bin/bash

MOD="BankCrawl.Canada"

iex -S mix run -e "Crawly.Engine.start_spider($MOD)"
