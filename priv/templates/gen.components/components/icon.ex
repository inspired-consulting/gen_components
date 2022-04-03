defmodule <%= components_module %>.Icon do
  use <%= web_module %>, :component

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

  def icon_delete(assigns) do
    assigns = assign_new(assigns, :class, fn -> "" end)
    attrs = assigns_to_attributes(assigns, [:name, :class])

    ~H"""
    <.icon name="trash" class={"text-danger #{@class}"} {attrs}/>
    """
  end

  def icon_edit(assigns) do
    assigns = assign_new(assigns, :class, fn -> "" end)
    attrs = assigns_to_attributes(assigns, [:name, :class])

    ~H"""
    <.icon name="pencil" class={"text-primary #{@class}"} {attrs}/>
    """
  end

  def icon_add(assigns) do
    assigns = assign_new(assigns, :class, fn -> "" end)
    attrs = assigns_to_attributes(assigns, [:name, :class])

    ~H"""
    <.icon name="plus" class={"text-success #{@class}"} {attrs}/>
    """
  end
end
