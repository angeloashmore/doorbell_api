use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :doorbell_api, DoorbellApi.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  cache_static_lookup: false,
  check_origin: false,
  watchers: []

# Watch static and templates for browser reloading.
config :doorbell_api, DoorbellApi.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{web/views/.*(ex)$},
      ~r{web/templates/.*(eex)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development.
# Do not configure such in production as keeping
# and calculating stacktraces is usually expensive.
config :phoenix, :stacktrace_depth, 20

# Configure your database
config :doorbell_api, DoorbellApi.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "angeloashmore",
  password: "",
  database: "doorbell_api_dev",
  pool_size: 10

# Configure Stripe account
config :stripe,
  secret_key: "sk_test_QSGWG4k2CfgfD10hXdWVdOXc"

# Configure Auth0 account
config :auth0,
  client_id: "9qmS3UpQ2YdtU9ni72SqQCFD3qEprz3X",
  client_secret: "D-oDfwNGXbafthQjyEqwZnyURecSJBKfOv8jeENDXtuMU67M9oFpnhUu0fbBjb0U",
  doorbell_client_id: "rdSmqCS5jb1k4WPcEZLg/+KajhmaKp5o2PtBeKNC3uM=",
  doorbell_client_secret: "kV1M8T7+k95MfGqdBmj3ihTnouz4jPQN4U9hYHw4beU="
