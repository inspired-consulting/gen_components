import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :gen_components, GenComponentsWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "wtMyr7oRyfwh8O0lX365rf/5yvdmhrOzx3WxcjmG+3sMc8xvlZ6yxr9GWXYCNkO6",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
