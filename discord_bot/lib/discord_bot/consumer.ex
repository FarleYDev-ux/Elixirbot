defmodule DiscordBot.Consumer do
  use Nostrum.Consumer

  alias DiscordBot.Embeds
  
  @start_time System.monotonic_time(:second)

  def handle_event({:READY, _data, _ws_state}) do
    ping_command = %{
      name: "ping",
      description: "Responde com um Embed estilo Elixir!"
    }
    Nostrum.Api.ApplicationCommand.create_global_command(ping_command)

    daily_reward_command = %{
      name: "dailyreward",
      description: "Receba sua recompensa diária!"
    }
    Nostrum.Api.ApplicationCommand.create_global_command(daily_reward_command)

    balance_command = %{
      name: "balance",
      description: "Mostra seu saldo atual"
    }
    Nostrum.Api.ApplicationCommand.create_global_command(balance_command)

    help_command = %{
      name: "help",
      description: "Lista todos os comandos disponíveis"
    }
    Nostrum.Api.ApplicationCommand.create_global_command(help_command)
  end

  def handle_event({:INTERACTION_CREATE, interaction, _ws_state}) do
    case interaction.data.name do
      "ping" ->
        bot_latency = 23
        api_latency = 209
        
        uptime_seconds = System.monotonic_time(:second) - @start_time
        uptime_hours = div(uptime_seconds, 3600)
        uptime_minutes = div(rem(uptime_seconds, 3600), 60)
        uptime = "#{uptime_hours}h #{uptime_minutes}m"

        embed = Embeds.shard_info(bot_latency, api_latency, uptime)
        
        response = %{
          type: 4,
          data: %{
            embeds: [embed]
          }
        }
        Nostrum.Api.Interaction.create_response(interaction, response)

      "dailyreward" ->
        embed = Embeds.daily_reward(30, 1, 0)
        response = %{
          type: 4,
          data: %{
            embeds: [embed]
          }
        }
        Nostrum.Api.Interaction.create_response(interaction, response)

      "balance" ->
        embed = Embeds.user_balance(0)
        response = %{
          type: 4,
          data: %{
            embeds: [embed]
          }
        }
        Nostrum.Api.Interaction.create_response(interaction, response)

      "help" ->
        embed = Embeds.help_embed()
        response = %{
          type: 4,
          data: %{
            embeds: [embed]
          }
        }
        Nostrum.Api.Interaction.create_response(interaction, response)

      _ ->
        :ignore
    end
  end

  def handle_event(_event) do
    :noop
  end
end
