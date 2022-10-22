defmodule <%= components_module %>.Icon do
  use <%= web_module %>, :component

  @moduledoc ~S"""
  ## icons

  The `<.icons name="..." />` component is an adapter function to easily use other
  icon packages within heex.

  the `icons/0` function is only used for the catalog.

  ## icon default type

  The icon default type is specific to the icen package you use. For hero icons there are the types `"solid"` and `"outline"`. Configure the the default type as followes:

  ```elixir
  config :gen_components, :semantic_icon, [
    {:delete, :danger, "trash"},
    {:edit, :primary, "pencil"},
    {:add, :success, "plus"}
  ]
  ```

  ## semantic icons

  "Code what you mean, not what you need to achieve it."

  So you can configure meaningfull icon components like `<.icon_detele />`.
  You can configure the semantic icons like:

  ```elixir
  config :gen_components, :semantic_icon, [
    {:delete, :danger, "trash"},
    {:edit, :primary, "pencil"},
    {:add, :success, "plus"}
  ]
  ```

  This will generate 3 icon components. The first will call `icon/0` like that,
  and will be named `<.icon_delete/>`:

  ```heex
  <.icon name="trash" class={"text-danger #{@class}"} {attrs}/>
  ```
  """

  require Heroicons
  @icons (Heroicons.__info__(:functions) |> Enum.map(&elem(&1, 0))) -- [:__components__]

  @doc """
  List all vendor icon names. Used for the catalogue.
  """
  def icons(), do: @icons

  @doc """
  A general icon component for hero icons.

  ## Attributes
  * name: the name of the hero icon
  """
  def icon(assigns) do
    apply(Heroicons, String.to_existing_atom("#{assigns.name}"), [assigns])
  end
<%= for {semantic_name, style, icon_name} <- semantic_icons do %>
  def icon_<%= semantic_name %>(assigns) do
    assigns = assign_new(assigns, :class, fn -> "" end)
    attrs = assigns_to_attributes(assigns, [:name, :class])

    ~H"""
    <.icon name="<%= icon_name %>" class={"text-<%= style %> #{@class}"} {attrs}/>
    """
  end
<% end %>
end
