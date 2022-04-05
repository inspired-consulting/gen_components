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

  @hero_icons_path "priv/solid"
  alias Heroicons.Solid
  alias Heroicons.Outline

  @icons Application.app_dir(:heroicons, @hero_icons_path)
         |> File.ls!()
         |> Enum.map(&Path.basename/1)
         |> Enum.map(&Path.rootname/1)
         |> Enum.map(&{&1, String.replace(&1, "-", "_") |> String.to_atom()})
         |> Map.new()

  @doc """
  List all vendor icon names. Used for the catalogue.
  """
  def icons(), do: Map.keys(@icons)

  @doc """
  A general icon component for hero icons.

  ## Attributes
  * name: the name of the hero icon
  * type: "outline" | "solid" (specific to hero icons)
  """
  def icon(assigns) do
    assigns = assign_new(assigns, :type, fn -> <%= inspect(default_icon_type) %> end)
    attrs = assigns_to_attributes(assigns, [:name, :type])

    ~H"""
    <%%= case @type do %>
      <%% "outline" -> %><%%= apply(Outline, iconf_by_name(@name), [attrs]) %>
      <%% "solid" -> %><%%= apply(Solid, iconf_by_name(@name), [attrs]) %>
    <%% end %>
    """
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
# icon function name by icon name
defp iconf_by_name(name), do: Map.fetch!(@icons, name)
end
