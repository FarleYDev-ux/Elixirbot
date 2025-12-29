import Config

# Nostrum expects the token directly as a string or a function.
# When using System.get_env, it's best to ensure it's loaded correctly.
config :nostrum,
  token: System.get_env("DISCORD_TOKEN"),
  gateway_intents: [:guild_messages, :message_content, :guilds, :direct_messages]

config :discord_bot, DiscordBot.Repo,
  database: System.get_env("PGDATABASE") || "discord_bot",
  username: System.get_env("PGUSER") || "postgres",
  password: System.get_env("PGPASSWORD") || "postgres",
  hostname: System.get_env("PGHOST") || "localhost",
  port: (System.get_env("PGPORT") || "5432") |> String.to_integer(),
  stacktrace: true,
  show_sensitive_data_on_error: true,
  pool_size: 10

config :discord_bot,
  ecto_repos: [DiscordBot.Repo]

