defmodule ComponentsDemo.MixProject do
  use Mix.Project

  def project do
    [
      app: :components_demo,
      version: "0.1.0",
      elixir: "~> 1.13",
      deps: deps()
    ]
  end

  def application do
    [
      mod: {ComponentsDemo.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:phoenix, "~> 1.6.0"},
      {:phoenix_live_view, "~> 0.17.0"},
      {:phoenix_ecto, "~> 4.4.0"},
      {:heroicons, "~> 0.3.0"},
      {:jason, "~> 1.3.0"},
      {:plug_cowboy, "~> 2.5.0"},
      {:phoenix_live_reload, "~> 1.3.0", only: [:dev]},
      {:esbuild, "~> 0.4.0", runtime: Mix.env() == :dev},
      {:gen_components, path: "./../", only: [:dev]}
    ]
  end
end
