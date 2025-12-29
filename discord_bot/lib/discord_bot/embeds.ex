defmodule DiscordBot.Embeds do
  @moduledoc """
  Utilitário para criar embeds no estilo Elixir (Roxo/Escuro).
  """

  alias Nostrum.Struct.Embed

  @elixir_purple 0x7F4DB0

  def base do
    %Embed{}
    |> Embed.put_color(@elixir_purple)
    |> Embed.put_footer("Powered by Elixir 1.18 & Nostrum", "https://elixir-lang.org/images/logo/logo-symbol.png")
    |> Embed.put_timestamp(DateTime.utc_now() |> DateTime.to_iso8601())
  end

  def info(title, description) do
    base()
    |> Embed.put_title(title)
    |> Embed.put_description(description)
  end

  def shard_info(shard_id, bot_latency, api_latency) do
    base()
    |> Embed.put_title("<:Pong:1455224028146176143> **Pong! Aqui esta atualmente minha latencia e a latencia da api**")
    |> Embed.put_field("<:Antenna:1455220982364246036> **Bot**", "#{bot_latency}ms", true)
    |> Embed.put_field("<:bssola:1455218184046252240> **API**", "#{api_latency}ms", true)
    |> Embed.put_field("<:Config:1455222961702441185> **Shard**", "#{shard_id}", true)
    |> Embed.put_footer("Powered by Elixir 1.18 Dev @gomezfy_", "https://elixir-lang.org/images/logo/logo-symbol.png")
  end

  def daily_reward(amount, streak, bonus) do
    %Embed{}
    |> Embed.put_color(@elixir_purple)
    |> Embed.put_title("<:coins:1455236526316191806> **Recompensa Diária**")
    |> Embed.put_description("Você recebeu <:Coin:1455236125034680351> **R$ #{amount}** na carteira")
    |> Embed.put_field("<:sequer:1455238218378121374> **Sequência atual**", "**#{streak}** dias consecutivos", true)
    |> Embed.put_field("<:bnus:1455238661581963365> **Bônus aplicado**", if(streak > 1, do: "**+#{bonus}%**", else: "Nenhum"), true)
    |> Embed.put_footer("Volte em 12h para manter a sequência!")
    |> Embed.put_timestamp(DateTime.utc_now() |> DateTime.to_iso8601())
  end

  def daily_reward_wait(hours_left, next_claim_time \\ nil) do
    time_display = if next_claim_time do
      next_claim_unix = next_claim_time
        |> DateTime.from_naive!("Etc/UTC")
        |> DateTime.to_unix()
      "<t:#{next_claim_unix}:R>"
    else
      "**#{hours_left}h**"
    end

    %Embed{}
    |> Embed.put_color(@elixir_purple)
    |> Embed.put_title("<:coins:1455236526316191806> **Recompensa Diária**")
    |> Embed.put_description("Você já coletou sua recompensa! Tente novamente #{time_display}")
    |> Embed.put_footer("Volte para manter sua sequência!")
    |> Embed.put_timestamp(DateTime.utc_now() |> DateTime.to_iso8601())
  end

  def user_stats(user) do
    base()
    |> Embed.put_title("<:sequer:1455238218378121374> **Estatísticas do Usuário**")
    |> Embed.put_description("Dados completos de ganhos e atividade")
    |> Embed.put_field("<:Coin:1455236125034680351> **Total Ganho**", "**R$ #{user.total_earned}**", true)
    |> Embed.put_field("<:sequer:1455238218378121374> **Sequência Atual**", "**#{user.streak}** dias", true)
    |> Embed.put_field("<:bnus:1455238661581963365> **Último Ganho**", 
      if(user.last_collected_at, do: format_relative_time(user.last_collected_at), else: "Nunca"), true)
  end

  def user_balance(total_earned) do
    base()
    |> Embed.put_title("<:coins:1455236526316191806> **Carteira**")
    |> Embed.put_description("Seu saldo atual na economia do servidor")
    |> Embed.put_field("<:Coin:1455236125034680351> **Saldo**", "**R$ #{total_earned}**", false)
    |> Embed.put_footer("Colete sua recompensa diária com /dailyreward!")
  end

  def help_embed do
    base()
    |> Embed.put_title("📚 **Ajuda - Comandos Disponíveis**")
    |> Embed.put_description("Bem-vindo ao bot de recompensas em Elixir!")
    |> Embed.put_field("<:Pong:1455224028146176143> **/ping**", "Mostra latência do bot", false)
    |> Embed.put_field("<:coins:1455236526316191806> **/dailyreward**", "Coleta R$30 a cada 12h (com bônus de 5% por streak)", false)
    |> Embed.put_field("<:Coin:1455236125034680351> **/balance**", "Mostra seu saldo total", false)
    |> Embed.put_field("<:sequer:1455238218378121374> **/stats**", "Estatísticas completas de ganhos", false)
    |> Embed.put_field("ℹ️ **Elixir Power**", "Bot construído com concorrência e performance máxima em Elixir! ⚡", false)
  end

  defp format_relative_time(naive_datetime) do
    now = NaiveDateTime.utc_now()
    diff_seconds = NaiveDateTime.diff(now, naive_datetime)
    
    cond do
      diff_seconds < 60 -> "Agora mesmo"
      diff_seconds < 3600 -> "#{div(diff_seconds, 60)} minutos atrás"
      diff_seconds < 86400 -> "#{div(diff_seconds, 3600)} horas atrás"
      true -> "#{div(diff_seconds, 86400)} dias atrás"
    end
  end
end
