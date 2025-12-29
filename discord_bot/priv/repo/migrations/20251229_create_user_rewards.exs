defmodule DiscordBot.Repo.Migrations.CreateUserRewards do
  use Ecto.Migration

  def change do
    create table(:user_rewards) do
      add :user_id, :string, null: false
      add :last_collected_at, :naive_datetime
      add :streak, :integer, default: 0
      add :total_earned, :integer, default: 0

      timestamps()
    end

    create unique_index(:user_rewards, [:user_id])
  end
end
