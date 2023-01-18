# GenComponents
<!-- MDOC !-->

* Generates a set of UI heex components to start a project from.
* Generates a component catalogue live view.
* Uses [daisyUI](https://daisyui.com/) build on top of [tailwindcss](https://tailwindcss.com/)

The generated components are meant to be a point to start from. 
They will reside in your project space, where you can easily adjust them to your needs.

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

To see the demo project in action:

* checkout the project
* cd to the `components_demo` gonzo project
* call `mix gen.components`
* call `iex -S mix phx.server`
* visit <https://localhost:4000> or <https://localhost:4000/catalogue>

## Installation

The package can be installed by adding `gen_components` to your list of
dependencies in `mix.exs`.

```elixir
def deps do
  [
    {:gen_components, "~> 0.1.0", only: [:dev]},
    # optional icon package
    {:heroicons, "~> 0.5.0"}
  ]
end
```

The generated components are meant to be changed after being generated. So it is
recommendet to add the components folder to your live reload dev config:

```elixir
# Watch static and templates for browser reloading.
config :my_app_web, MyAppWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"lib/my_app_web/(live|views|components)/.*(ex)$",
      ~r"lib/my_app_web/templates/.*(eex)$"
    ]
  ]


```

Run `npm install` in `components_demo/assets`, to use tailwind and daisyUI

### Install the catalogue

Add the folowing to your `router.ex`:

```elixir
if Mix.env() == :dev do
  import MyAppWeb.ComponentsCatalogueLive
  catalogue_routes "/catalogue"
end
```

### Install the Javascript custom components

The custom components are used to fomrat numbers and dates in the browsers locale.
To make it work add the following to your `app.js`

```javascript
// to activate local format custom components
import "./components"
```

## How to contribute
1. Use the gonzo project to build your component.
2. Adapt it to the templates
