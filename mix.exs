defmodule GenComponents.MixProject do
  use Mix.Project

  def project do
    [
      app: :gen_components,
      version: "0.1.0",
      elixir: "~> 1.13",
      deps: deps()
    ]
  end

  def application do
    [
      mod: {GenComponents.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:esbuild, "~> 0.3", runtime: Mix.env() == :dev},
      {:floki, ">= 0.30.0", only: :test},
      {:jason, "~> 1.2"},
      {:phoenix_html, "~> 3.0"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, "~> 0.17.7"},
      {:phoenix, "~> 1.6.0"},
      {:plug_cowboy, "~> 2.5"}
    ]
  end
end
