defmodule <%= catalogue_module %>.Paginations do
  use <%= web_module %>, :live_component

  import <%= components_module %>.Pagination
  alias __MODULE__.Page

  @impl Phoenix.LiveComponent
  def render(assigns) do
    ~H"""
    <div>
      <section style="margin: 1rem;">
        <h2>Pagination</h2>
        <ul>
          <%%= for entry <- @page.entries do %>
            <li><%%= entry %></li>
          <%% end %>
        </ul>
        <.pagination page={@page} let={%{class: class, to_page: to_page}}>
          <a href="#" phx-target={@myself} phx-click="to_page" phx-value-page={to_page} class={class}>
            <%%= to_page %>
          </a>
        </.pagination>
      </section>

      <section style="border-top: 1px solid black; margin: 1rem;">
        <h2>Pagination with prev and next</h2>
        <ul>
          <%%= for entry <- @page.entries do %>
            <li><%%= entry %></li>
          <%% end %>
        </ul>
        <.pagination page={@page} let={%{class: class, to_page: to_page}}>
          <:prev let={%{class: class, to_page: to_page}}>
            <a href="#" phx-target={@myself} phx-click="to_page" phx-value-page={to_page} class={class}>
              <.pagination_prev/>
            </a>
          </:prev>
          <:next let={%{class: class, to_page: to_page}}>
            <a href="#" phx-target={@myself} phx-click="to_page" phx-value-page={to_page} class={class}>
              <.pagination_next/>
            </a>
          </:next>
          <a href="#" phx-target={@myself} phx-click="to_page" phx-value-page={to_page} class={class}>
            <%%= to_page %>
          </a>
        </.pagination>
      </section>
    </div>
    """
  end

  @impl Phoenix.LiveComponent
  def update(_params, socket) do
    {:ok, assign(socket, page: Page.from_list(build_entries(199)))}
  end

  @impl Phoenix.LiveComponent
  def handle_event("to_page", %{"page" => page_number}, socket) do
    {:noreply,
     update(socket, :page, fn page ->
       Page.set_page_number(page, String.to_integer(page_number))
     end)}
  end

  defp build_entries(size) do
    Enum.map(1..size, &"Item no #{&1}")
  end
end
