# Pipeline check giving errors
defmodule BankCrawl.Pipelines.NotEmpty do
  @behaviour Crawly.Pipelines

  def init(opts), do: opts

  def run(item, state, opts \\ []) do
    opts = Enum.into(opts, %{fields: nil})
    fields = Map.get(opts, :fields, [])

    if not_empty?(item, fields) do
      {:ok, item, state}
    else
      {:drop, state}
    end
  end

  defp not_empty?(_item, []) do
    false
  end

  defp not_empty?(item, fields) do
    # Implement your condition to check if the current item is an article.
    # For example, you can check for the presence and non-empty value of a specific key:
    #
    # Map.has_key?(item, :content) and not is_nil(item[:content]) and item[:content] != ""
    #
    # Adjust this condition according to your specific use case.

    fields
    |> Enum.map(fn key ->
      Map.has_key?(item, key) and not is_nil(item[key]) and item[key] != ""
    end)
    |> Enum.all?()
  end
end
