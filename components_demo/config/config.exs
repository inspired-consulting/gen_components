import Config

# Configures the endpoint
config :components_demo, ComponentsDemoWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: ComponentsDemoWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: ComponentsDemo.PubSub,
  live_view: [signing_salt: "MtIqQmNz"]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.16.17",
  default: [
    args: ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

config :tailwind,
  version: "3.1.6",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
