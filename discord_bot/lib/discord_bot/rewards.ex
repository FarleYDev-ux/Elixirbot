defmodule DiscordBot.Rewards do
  import Ecto.Query
  alias DiscordBot.Repo
  alias DiscordBot.Schema.UserReward

  def calculate_reward(streak) do
    base_amount = 30
    bonus_percentage = if streak > 1, do: (streak - 1) * 5, else: 0
    bonus_amount = floor(base_amount * bonus_percentage / 100)
    {base_amount + bonus_amount, bonus_percentage}
  end

  def get_or_create_user(user_id) do
    case Repo.get_by(UserReward, user_id: user_id) do
      nil ->
        {:ok, user} = %UserReward{}
        |> UserReward.changeset(%{user_id: user_id})
        |> Repo.insert()
        user

      user ->
        user
    end
  end

  def claim_reward(user_id) do
    user = get_or_create_user(user_id)
    now = NaiveDateTime.utc_now()

    case user.last_collected_at do
      nil ->
        # First time claiming
        {amount, bonus} = calculate_reward(1)
        update_user(user, amount, 1, bonus)

      last_claimed ->
        hours_passed = NaiveDateTime.diff(now, last_claimed) / 3600

        if hours_passed >= 12 do
          # Can claim again
          new_streak = user.streak + 1
          {amount, bonus} = calculate_reward(new_streak)
          update_user(user, amount, new_streak, bonus)
        else
          # Can't claim yet
          hours_left = 12 - floor(hours_passed)
          next_claim_time = NaiveDateTime.add(last_claimed, 12 * 3600)
          {:wait, hours_left, user, next_claim_time}
        end
    end
  end

  defp update_user(user, amount, streak, bonus) do
    {:ok, updated_user} =
      user
      |> UserReward.changeset(%{
        last_collected_at: NaiveDateTime.utc_now(),
        streak: streak,
        total_earned: user.total_earned + amount
      })
      |> Repo.update()

    {:ok, updated_user, amount, bonus}
  end

  def reset_inactive_streaks do
    # Reset streak for users who haven't claimed in 24+ hours
    cutoff_time = NaiveDateTime.add(NaiveDateTime.utc_now(), -86400)

    UserReward
    |> where([u], u.last_collected_at < ^cutoff_time and u.streak > 0)
    |> Repo.update_all(set: [streak: 0])
  end
end
