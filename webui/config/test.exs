import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :webui, Webui.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "webui_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :webui, WebuiWeb.Endpoint,
  http: [ip: {0, 0, 0, 0}, port: 4002],
  secret_key_base: "UY0vuSmVNMlgc+eb9tQuJ/psQMk4RZPQJhifOjNSjWk9H3Dq/Ezjst0Anvpoj/za",
  server: false

# In test we don't send emails.
config :webui, Webui.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
