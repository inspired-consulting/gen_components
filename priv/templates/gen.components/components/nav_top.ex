defmodule <%= components_module %>.NavTop do
  use <%= web_module %>, :component

  alias Phoenix.LiveView.JS
  import <%= components_module %>.Icon

  defp collaps_id(id), do: "#{id}-collapse"

  defp toggle_nav(js \\ %JS{}, id) do
    js
    |> JS.remove_class("show", to: "##{collaps_id(id)}.show")
    |> JS.set_attribute({"aria-expanded", "false"}, to: "##{collaps_id(id)}.show")
    |> JS.add_class("show", to: "##{collaps_id(id)}:not(.show)")
    |> JS.set_attribute({"aria-expanded", "true"}, to: "##{collaps_id(id)}:not(.show)")
  end

  defp close_nav_dropdown(js \\ %JS{}, id) do
    js
    |> JS.remove_class("show", to: "##{id}.show")
    |> JS.remove_class("show", to: "##{id}.show .dropdown-menu")
    |> JS.set_attribute({"aria-expanded", "false"}, to: "##{id}.show .dropdown-menu")
  end

  defp toggle_nav_dropdown(js \\ %JS{}, id) do
    js
    |> close_nav_dropdown(id)
    |> JS.add_class("show", to: "##{id}:not(.show)")
    |> JS.add_class("show", to: "##{id}:not(.show) .dropdown-menu")
    |> JS.set_attribute({"aria-expanded", "true"}, to: "##{id}:not(.show) .dropdown-menu")
  end

  def nav_top_item(assigns) do
    assigns = assign_new(assigns, :class, fn -> "" end)
    attrs = assigns_to_attributes(assigns, [:class])

    ~H"""
    <li class={"nav-item #{@class}"} {attrs}><%%= render_slot(@inner_block) %></li>
    """
  end

  def nav_top_item_dropdown(assigns) do
    assigns = assign_new(assigns, :class, fn -> "" end)
    attrs = assigns_to_attributes(assigns, [:class, :id, :label])

    ~H"""
    <li class="nav-item dropdown" id={@id} {attrs}>
      <a class="nav-link dropdown-toggle" phx-click={toggle_nav_dropdown(@id)} href="#" id={"#{@id}-label"} data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false"><%%= @label %></a>
      <ul class="dropdown-menu" aria-labelledby={"#{@id}-label"} phx-click-away={close_nav_dropdown(@id)} phx-window-keydown={close_nav_dropdown(@id)} phx-key="escape">
        <%%= render_slot(@inner_block) %>
      </ul>
    </li>
    """
  end

  defp nav_top_brand(assigns) do
    assigns = assign_new(assigns, :to, fn -> "/" end)
    assigns = assign_new(assigns, :class, fn -> "" end)
    attrs = assigns_to_attributes(assigns, [:class, :to])

    ~H"""
    <a class={"navbar-brand #{@class}"} href={@to} {attrs}><%%= render_slot(@inner_block) %></a>
    """
  end

  def nav_top(assigns) do
    assigns = assign_new(assigns, :id, fn -> "nav-top" end)
    assigns = assign_new(assigns, :class, fn -> "" end)
    assigns = assign_new(assigns, :brand, fn -> [] end)
    attrs = assigns_to_attributes(assigns, [:id, :brand, :class])

    ~H"""
    <nav class={"navbar navbar-expand-md #{@class}"} aria-label="navbar top" {attrs}>
      <div class="container-fluid">
        <%%= for brand <- @brand do %>
          <.nav_top_brand {brand}><%%= render_slot(brand) %></.nav_top_brand>
        <%% end %>
        <button class="navbar-toggler" type="button" aria-label="Toggle navigation" phx-click={toggle_nav(@id)}>
          <.icon_burger_menu style="width: 1.2em;" />
        </button>

        <div class="navbar-collapse collapse" id={collaps_id(@id)} aria-expanded="false">
          <ul class="navbar-nav me-auto mb-2 mb-md-0">
            <%%= render_slot(@inner_block) %>
          </ul>
        </div>
      </div>
    </nav>
    """
  end
end
