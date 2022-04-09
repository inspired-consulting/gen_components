defmodule Mix.Tasks.Gen.Components do
  @shortdoc "Generates a set of components to start from."
  @external_resource readme = "README.md"
  @moduledoc File.read!(readme)
             |> String.split("<!-- MDOC !-->")
             |> Enum.fetch!(1)

  use Mix.Task

  @default_components_module "components"

  @default_styles [:primary, :secondary, :success, :danger, :warning, :info]
  @default_icon_type "solid"
  @default_semantic_icons [
    {:delete, :danger, "trash"},
    {:edit, :primary, "pencil"},
    {:add, :success, "plus"}
  ]

  @template_path Path.join(["priv", "templates", "gen.components"])
  @template_file_path Path.join(Application.app_dir(:gen_components), @template_path)

  @catalogue_template_path Path.join(@template_path, "catalogue")
  @components_template_path Path.join(@template_path, "components")

  @catalogue_template_file_path Path.join(@template_file_path, "catalogue")
  @components_template_file_path Path.join(@template_file_path, "components")

  def run(argv) do
    if Mix.Project.umbrella?() do
      Mix.raise("mix gen.components must be invoked from within your web application app root directory")
    end

    if !Mix.Phoenix.otp_app() do
      Mix.raise("mix gen.components must be invoked from an app root directory")
    end

    {parsed, _argv, _errors} =
      OptionParser.parse(
        argv,
        strict: [output: :string],
        aliases: [o: :output]
      )

    otp_app = Mix.Phoenix.otp_app()
    components_module = parsed[:output] || @default_components_module
    components_binding = Mix.Phoenix.inflect(components_module)
    catalogue_binding = Mix.Phoenix.inflect("components_catalogue")

    {catalogue_path, components_path, components_scoped, catalogue_scoped, web_module} =
      if in_umbrella?() do
        {
          Mix.Phoenix.context_lib_path(otp_app, "live"),
          Mix.Phoenix.context_lib_path(otp_app, "#{components_binding[:path]}"),
          components_binding[:scoped],
          catalogue_binding[:scoped],
          catalogue_binding[:base]
        }
      else
        {
          Mix.Phoenix.web_path(otp_app, "live"),
          Mix.Phoenix.web_path(otp_app, "#{components_binding[:path]}"),
          components_binding[:scoped],
          catalogue_binding[:scoped],
          catalogue_binding[:web_module]
        }
      end

    bindings = [
      components_scoped: components_scoped,
      components_module: "#{web_module}.#{components_scoped}",
      catalogue_scoped: "#{catalogue_scoped}Live",
      catalogue_module: "#{web_module}.#{catalogue_scoped}Live",
      web_module: web_module,
      styles: config_styles(),
      semantic_icons: config_semantic_icons(),
      default_icon_type: config_default_icon_type()
    ]

    Mix.Phoenix.copy_from(
      paths(),
      @catalogue_template_path,
      bindings,
      Enum.map(
        find_ex(@catalogue_template_file_path),
        &{:eex, &1, Path.join(catalogue_path, "#{&1}")}
      )
    )

    Mix.Phoenix.copy_from(
      paths(),
      @components_template_path,
      bindings,
      Enum.map(
        find_ex(@components_template_file_path),
        &{:eex, &1, Path.join(components_path, "#{&1}")}
      )
    )
  end

  defp paths do
    [".", :gen_components]
  end

  defp find_ex(folder) do
    "#{folder}/**/*.ex"
    |> Path.wildcard()
    |> Enum.map(&Path.relative_to(&1, "#{folder}"))
  end

  defp in_umbrella?() do
    case Mix.Project.config()[:config_path] do
      "../../" <> _ -> true
      _ -> false
    end
  end

  defp config_styles(), do: Application.get_env(:gen_components, :styles, @default_styles)

  defp config_semantic_icons(),
    do: Application.get_env(:gen_components, :semantic_icon, @default_semantic_icons)

  defp config_default_icon_type(),
    do: Application.get_env(:gen_components, :default_icon_type, @default_icon_type)
end
