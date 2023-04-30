#! /bin/bash

mix release --overwrite
mv ./burrito_out/bank_crawl_* ./burrito_out/bank_crawl
