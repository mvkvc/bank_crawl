defmodule BankCrawl.Utils do
  def not_missing?(item, fields \\ []) do
    fields
    |> Enum.map(fn key ->
      Map.has_key?(item, key) and not is_nil(item[key]) and item[key] != ""
    end)
    |> Enum.all?()
  end
end
