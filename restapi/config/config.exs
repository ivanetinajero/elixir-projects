# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :restapi,
  ecto_repos: [Restapi.Repo]

# Configures the endpoint
config :restapi, RestapiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "fq2esXDOut/magkXvZOxe5ODs+0V7qb+1FWpg+x6MWhlmwv72iCbZCSAYJjL+3dN",
  render_errors: [view: RestapiWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Restapi.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "LaGOSS8r"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
