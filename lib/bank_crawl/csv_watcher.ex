defmodule BankCrawl.CSVWatcher do
  use GenServer
  alias BankCrawl.Utils

  # TODO: Current issue is that this needs to be stopped eventually

  def start_link(folder, interval \\ 1000) do
    GenServer.start_link(__MODULE__, {folder, interval})
  end

  def init({folder, interval}) do
    schedule_update(interval)
    {:ok, %{folder: folder, interval: interval}}
  end

  def handle_info(:update, state) do
    files = File.ls!(Path.absname(state.folder))

    result =
      Enum.map(files, fn file ->
        Utils.print_csv_length(file)
      end)

    schedule_update(state.interval)
    {:noreply, state}
  end

  defp schedule_update(interval) do
    Process.send_after(self(), :update, interval)
  end
end
