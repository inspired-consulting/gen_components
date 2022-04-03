defmodule <%= catalogue_module %>.Icons do
  use <%= web_module %>, :component

  import <%= components_module %>.Icon

  defp frame(assigns) do
    ~H"""
    <div title={@title} style="
      border: 1px solid black;
      width: 5rem;
      height: 5rem;
      margin: 0.5rem;
      border-radius: 0.3rem;
      display: flex;
      justify-content: center;
      align-items: center;
    "><%%= render_slot(@inner_block) %></div>
    """
  end

  def icons(assigns) do
    ~H"""
    <section>
      <h2>Semantic Icons</h2>
      <div style="display: flex; flex-wrap: wrap;">
        <.frame title="icon_delete"><.icon_delete style="width: 3rem; height: 3rem;"/></.frame>
        <.frame title="icon_add"><.icon_add style="width: 3rem; height: 3rem;"/></.frame>
        <.frame title="icon_edit"><.icon_edit style="width: 3rem; height: 3rem;"/></.frame>
      </div>
    </section>
    <section style="margin-top: 1rem;">
      <h2>All Icons</h2>
      <div style="display: flex; flex-wrap: wrap;">
        <%%= for i <- icons() do %>
          <.frame title={i}><.icon name={i} style="width: 3rem; height: 3rem;"/></.frame>
        <%% end %>
      </div>
    </section>
    """
  end
end
