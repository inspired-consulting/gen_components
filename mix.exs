defmodule GenComponents.MixProject do
  use Mix.Project

  def project do
    [
      app: :gen_components,
      version: "0.1.0",
      elixir: "~> 1.13",
      name: "gen.components",
      description: "Generates a set of UI heex components to start a project from.",
      source_url: "https://github.com/inspired-consulting/gen_components",
      package: package(),
      deps: deps(),
      docs: docs()
    ]
  end

  defp package() do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/inspired-consulting/gen_components"},
      maintainers: ["inspired-consulting"]
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: [
        "README.md"
      ]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:phoenix, ">= 1.6.0"},
      {:phoenix_live_view, ">= 0.17.0"},
      {:jason, ">= 1.2.0", only: [:test], optional: true},
      {:heroicons, ">= 0.3.0", optional: true}
    ]
  end
end
