use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :doorbell_api, DoorbellApi.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Set a higher stacktrace during test
config :phoenix, :stacktrace_depth, 20

# Configure your database
config :doorbell_api, DoorbellApi.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "angeloashmore",
  password: "",
  database: "doorbell_api_test",
  pool: Ecto.Adapters.SQL.Sandbox

# Configure Stripe account
config :stripe,
  secret_key: "sk_test_QSGWG4k2CfgfD10hXdWVdOXc"

# Configure Auth0 account
config :auth0,
  client_id: "g9Szm80Ac6T4LJ5t1cUa8AH77ZYFz7s9",
  client_secret: "cuhRKugh1cNejCJjWEsI7BIAd6EvNT7uHujuDwlqh-nCXJhm9V9AI6VP99zhEO3r"

# Configure Canary
config :canary,
  repo: DoorbellApi.Repo
