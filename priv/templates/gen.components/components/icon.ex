defmodule <%= components_module %>.Icon do
  use <%= web_module %>, :component

  # {semantic_name, class, icon_name}
  @hero_icons_path "priv/solid"
  @default_type "solid"
  alias Heroicons.Solid
  alias Heroicons.Outline

  @icons Application.app_dir(:heroicons, @hero_icons_path)
         |> File.ls!()
         |> Enum.map(&Path.basename/1)
         |> Enum.map(&Path.rootname/1)
         |> Enum.map(&{&1, String.replace(&1, "-", "_") |> String.to_atom()})
         |> Map.new()

  def icons(), do: Map.keys(@icons)

  defp iconf_by_name(name), do: Map.fetch!(@icons, name)

  def icon(assigns) do
    assigns = assign_new(assigns, :type, fn -> @default_type end)
    attrs = assigns_to_attributes(assigns, [:name, :type])

    ~H"""
    <%%= if @type == "outline", do: apply(Outline, iconf_by_name(@name), [attrs]), else: apply(Solid, iconf_by_name(@name), [attrs]) %>
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
<% end %>end
