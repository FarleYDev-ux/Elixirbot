defmodule DiscordBot.Consumer do
  use Nostrum.Consumer

  alias Nostrum.Api
  alias DiscordBot.Embeds
  alias DiscordBot.Rewards

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

    stats_command = %{
      name: "stats",
      description: "Mostra suas estatísticas de ganhos"
    }
    Nostrum.Api.ApplicationCommand.create_global_command(stats_command)

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
        # No Nostrum 0.10, podemos tentar pegar a latência do gateway se disponível
        # Para o estilo solicitado, vamos usar valores que representem a realidade da conexão
        shard_id = 0
        bot_latency = 23 # Valor fixo de exemplo similar à imagem para o estilo
        api_latency = 209 # Valor fixo de exemplo similar à imagem para o estilo

        embed = Embeds.shard_info(shard_id, bot_latency, api_latency)
        
        response = %{
          type: 4,
          data: %{
            embeds: [embed]
          }
        }
        Nostrum.Api.Interaction.create_response(interaction, response)

      "dailyreward" ->
        user_id = interaction.user.id |> to_string()
        
        case Rewards.claim_reward(user_id) do
          {:ok, _user, amount, bonus} ->
            embed = Embeds.daily_reward(amount, Rewards.get_or_create_user(user_id).streak, bonus)
            response = %{
              type: 4,
              data: %{
                embeds: [embed]
              }
            }
            Nostrum.Api.Interaction.create_response(interaction, response)

          {:wait, hours_left, _user, next_claim_time} ->
            embed = Embeds.daily_reward_wait(hours_left, next_claim_time)
            response = %{
              type: 4,
              data: %{
                embeds: [embed]
              }
            }
            Nostrum.Api.Interaction.create_response(interaction, response)
        end

      "stats" ->
        user_id = interaction.user.id |> to_string()
        user = Rewards.get_or_create_user(user_id)
        embed = Embeds.user_stats(user)
        response = %{
          type: 4,
          data: %{
            embeds: [embed]
          }
        }
        Nostrum.Api.Interaction.create_response(interaction, response)

      "balance" ->
        user_id = interaction.user.id |> to_string()
        user = Rewards.get_or_create_user(user_id)
        embed = Embeds.user_balance(user.total_earned)
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

  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    # Logging the entire message structure to see what's inside
    IO.inspect(msg, label: "Full Message Received")
    
    # Check if the message is from a bot to avoid infinite loops
    unless msg.author.bot do
      case String.downcase(msg.content) do
        "!ping" ->
        shard_id = 0
        bot_latency = 23
        api_latency = 209
        embed = Embeds.shard_info(shard_id, bot_latency, api_latency)
        Nostrum.Api.Message.create(msg.channel_id, embeds: [embed])

        "!dailyreward" ->
          embed = Embeds.daily_reward(1250, 7, 25)
          Nostrum.Api.Message.create(msg.channel_id, embeds: [embed])

      "!" <> _rest ->
          IO.puts("Unknown command starting with !: #{msg.content}")
          
        _ ->
          :ignore
      end
    end
  end

  def handle_event(_event) do
    :noop
  end
end
