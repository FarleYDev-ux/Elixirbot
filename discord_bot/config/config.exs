import Config

# Nostrum configuration - Discord token from environment variable
config :nostrum,
  token: System.get_env("DISCORD_TOKEN"),
  gateway_intents: [:guild_messages, :message_content, :guilds, :direct_messages]

# Logger configuration for production
config :logger,
  level: :info

