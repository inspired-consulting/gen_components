import Config

host = System.get_env("PHX_HOST") || "localhost"

if System.get_env("PHX_SERVER") && System.get_env("RELEASE_NAME") do
  config :components_demo, ComponentsDemoWeb.Endpoint,
    url: [host: host, port: 4000],
    server: true
end
