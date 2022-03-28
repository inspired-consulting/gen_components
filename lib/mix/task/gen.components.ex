defmodule Mix.Tasks.Gen.Components do
  @shortdoc "Generates a set of components to start from."

  @moduledoc """
  Generates a set of UI components to start a project from.
  It will also generate a component catalogue live view.

  ## Install the ctalogue

  Add the folowing to your router.ex:

  ```elixir
  live "/catalogue", ComponentsCatalogueLive, :index
  ```

  ## example usage

  ```bash
  $ mix gen.components
  $ mix gen.components -o other_components
  ```

  ## Options

    * `-o, --output` - lowercase name of the module,
    that will hold the components. Defaults to `components`
  """
  use Mix.Task

  @default_components_module "components"

  @template_path Path.join(["priv", "templates", "gen.components"])
  @template_file_path Path.join(Application.app_dir(:gen_components), @template_path)

  @catalogue_template_path Path.join(@template_path, "catalogue")
  @components_template_path Path.join(@template_path, "components")

  @catalogue_template_file_path Path.join(@template_file_path, "catalogue")
  @components_template_file_path Path.join(@template_file_path, "components")

  def run(argv) do
    if Mix.Project.umbrella?() do
      Mix.raise(
        "mix gen.components must be invoked from within your *_web application root directory"
      )
    end

    {parsed, _argv, _errors} =
      OptionParser.parse(
        argv,
        strict: [output: :string],
        aliases: [o: :output]
      )

    components_module = parsed[:output] || @default_components_module

    context_app = Mix.Phoenix.context_app()
    web_prefix = Mix.Phoenix.web_path(context_app)
    components_binding = Mix.Phoenix.inflect(components_module)
    catalogue_binding = Mix.Phoenix.inflect("components_catalogue")

    catalogue_binding =
      catalogue_binding
      |> Keyword.put(:compoents_scoped, components_binding[:scoped])

    Mix.Phoenix.copy_from(
      paths(),
      @catalogue_template_path,
      catalogue_binding,
      Enum.map(
        find_ex(@catalogue_template_file_path),
        &{:eex, &1, Path.join(web_prefix, "live/#{&1}")}
      )
    )

    Mix.Phoenix.copy_from(
      paths(),
      @components_template_path,
      components_binding,
      Enum.map(
        find_ex(@components_template_file_path),
        &{:eex, &1, Path.join(web_prefix, "#{components_binding[:path]}/#{&1}")}
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
end
