defmodule BankCrawl.Utils do
  def not_missing?(item, fields \\ []) do
    fields
    |> Enum.map(fn key ->
      Map.has_key?(item, key) and not is_nil(item[key]) and item[key] != ""
    end)
    |> Enum.all?()
  end

  def print_csv_length(file_path) do
    file = File.open(file_path)
    length = Enum.count(CSV.decode(file))
    File.close(file)
    IO.puts("CSV length #{file}: #{length}")
  end
end
