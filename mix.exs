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

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:phoenix, ">= 1.6.0"},
      {:phoenix_live_view, ">= 0.17.0"},
      {:heroicons, ">= 0.3.0", optional: true}
    ]
  end
end
