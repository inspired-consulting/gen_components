# GenComponents
<!-- MDOC !-->

* Generates a set of UI heex components to start a project from.
* Generates a component catalogue live view.

The generated componets are meant to be a point to start from. They will
reside in your project space, where you can easily adjust them to your needs.

## example usage

```bash
mix gen.components
mix gen.components -o other_components
```

## Options

* `-o, --output` - lowercase name of the module,
  that will hold the components. Defaults to `components`

## Example

See the [demo project](https://github.com/inspired-consulting/gen_components/tree/main/components_demo)
for some examples.

## Installation

The package can be installed by adding `gen_components` to your list of
dependencies in `mix.exs`.

```elixir
def deps do
  [
    {:gen_components, "~> 0.1.0", only: [:dev]},
    # optional icon package
    {:heroicons, "~> 0.3.0"}
  ]
end
```

## Install the catalogue

Add the folowing to your router.ex:

```elixir
if Mix.env() == :dev do
  import MyAppWeb.ComponentsCatalogueLive
  catalogue_routes "/catalogue"
end
```
