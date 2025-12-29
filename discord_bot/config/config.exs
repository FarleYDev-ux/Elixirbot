import Config

# Nostrum expects the token directly as a string or a function.
# When using System.get_env, it's best to ensure it's loaded correctly.
config :nostrum,
  token: System.get_env("DISCORD_TOKEN"),
  gateway_intents: [:guild_messages, :message_content, :guilds, :direct_messages]

config :discord_bot, DiscordBot.Repo,
  database: "heliumdb",
  username: "postgres",
  password: "password",
  hostname: "helium",
  port: 5432,
  stacktrace: true,
  show_sensitive_data_on_error: true,
  pool_size: 10

config :discord_bot,
  ecto_repos: [DiscordBot.Repo]

