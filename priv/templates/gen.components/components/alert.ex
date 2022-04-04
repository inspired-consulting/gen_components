defmodule <%= components_module %>.Alert do
  use <%= web_module %>, :component
<%= for style <- styles do %>
  def alert_<%= style %>(assigns) do
    assigns = assign_new(assigns, :class, fn -> "" end)
    attrs = assigns_to_attributes(assigns, [:class])

    ~H"""
    <div class={"alert alert-<%= style %> #{@class}"} role="alert" {attrs}><%%= render_slot(@inner_block) %></div>
    """
  end
<% end %>end
