defmodule CanadaTest do
  use ExUnit.Case
  doctest CrawlCb

  test "greets the world" do
    assert CrawlCb.hello() == :world
  end
end
