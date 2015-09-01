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
  client_id: "HWhD1xqXD4FOKpsrQCZv3AO9pO9W2ZTN",
  client_secret: "9PageTiEqQC4vKhRFPW4k9Twxm0Tr2lUVyPTTS83HZvwDt6H8Vzql9fJ-kvi3H3D",
  doorbell_client_id: "rdSmqCS5jb1k4WPcEZLg/+KajhmaKp5o2PtBeKNC3uM=",
  doorbell_client_secret: "kV1M8T7+k95MfGqdBmj3ihTnouz4jPQN4U9hYHw4beU="
