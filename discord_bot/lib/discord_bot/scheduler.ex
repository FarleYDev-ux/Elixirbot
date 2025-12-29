defmodule DiscordBot.Scheduler do
  use GenServer
  require Logger

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    schedule_work()
    {:ok, %{}}
  end

  def handle_info(:work, state) do
    Logger.info("Running reward streak reset scheduler")
    DiscordBot.Rewards.reset_inactive_streaks()
    schedule_work()
    {:noreply, state}
  end

  defp schedule_work do
    # Schedule to run every hour
    Process.send_after(self(), :work, 3600000)
  end
end
