defmodule DiscordBot.Schema.UserReward do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_rewards" do
    field :user_id, :string
    field :last_collected_at, :naive_datetime
    field :streak, :integer, default: 0
    field :total_earned, :integer, default: 0

    timestamps()
  end

  def changeset(user_reward, attrs) do
    user_reward
    |> cast(attrs, [:user_id, :last_collected_at, :streak, :total_earned])
    |> validate_required([:user_id])
    |> unique_constraint(:user_id)
  end
end
