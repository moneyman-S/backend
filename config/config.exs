# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :moneyman,
  ecto_repos: [Moneyman.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :moneyman, MoneymanWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "pLLu6mL7yD1B7Pb/OImU4E6AM8LDciXyXMR9VN6hpMBGrQL0WeYLLjn6NBmWs6bi",
  render_errors: [view: MoneymanWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Moneyman.PubSub,
  live_view: [signing_salt: "H1fUUPQT"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
