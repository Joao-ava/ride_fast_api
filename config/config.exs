# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :ride_fast, :scopes,
  user: [
    default: true,
    module: RideFast.Accounts.Scope,
    assign_key: :current_scope,
    access_path: [:user, :id],
    schema_key: :user_id,
    schema_type: :id,
    schema_table: :users,
    test_data_fixture: RideFast.AccountsFixtures,
    test_setup_helper: :register_and_log_in_user
  ]

config :ride_fast,
  ecto_repos: [RideFast.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :ride_fast, RideFastWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [json: RideFastWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: RideFast.PubSub,
  live_view: [signing_salt: "uEO0r0WJ"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :ride_fast, RideFast.Mailer, adapter: Swoosh.Adapters.Local

# Configures Elixir's Logger
config :logger, :default_formatter,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :ride_fast, RideFast.Guardian,
  issuer: "ride_fast",
  secret_key: "DopjBb3J8oDwOHzOjO9k682ip_auA3BCm88gerFojTbxEJ-dfvGSe_4wEGF0DIwI"

config :bcrypt_elixir, :log_rounds, 4

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
