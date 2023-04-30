#! /bin/bash

asdf install
mix do local.rebar --force, local.hex --force
mix escript.install hex livebook
asdf reshim
