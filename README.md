# GenComponents

Generates a set of UI components to start a project from.

It will also generate a component catalogue live view.

## Installation

The package can be installed by adding `gen_components` to your list of
dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:gen_components, "~> 0.1.0"}
  ]
end
```

## Install the ctalogue

Add the folowing to your router.ex:

```elixir
live "/catalogue", ComponentsCatalogueLive, :index
```

## example usage

```bash
mix gen.components
mix gen.components -o other_components
```

## Options

* `-o, --output` - lowercase name of the module,
  that will hold the components. Defaults to `components`
