defmodule <%= web_module %>.<%= scoped %>Live do
  use <%= web_module %>, :live_view

  alias <%= web_module %>.<%= scoped %>Live.Modals
  alias <%= web_module %>.<%= scoped %>Live.Paginations
  import <%= web_module %>.<%= scoped %>Live.Alerts

  @impl Phoenix.LiveView
  def render(assigns) do
    assigns = assign_new(assigns, :component, fn -> nil end)

    ~H"""
    <article style="display: flex; flex-direction: row; flex-wrap: wrap;">
      <h1 style="width: 100%;">gen.components</h1>
      <nav style="flex: 1;">
        <ul>
          <li><%%= live_patch "Alert", to: Routes.components_catalogue_path(@socket, :index, c: "alerts") %></li>
          <li><%%= live_patch "Modal", to: Routes.components_catalogue_path(@socket, :index, c: "modals") %></li>
          <li><%%= live_patch "Pagination", to: Routes.components_catalogue_path(@socket, :index, c: "paginations") %></li>
        </ul>
      </nav>
      <main style="flex: 5;">
        <%%= case @component do %>
          <%% "alerts" -> %><.alerts/>
          <%% "modals" -> %><.live_component module={Modals} id="modals"/>
          <%% "paginations" -> %><.live_component module={Paginations} id="paginations"/>
          <%% _ -> %><div/>
        <%% end %>
      </main>
    </article>
    """
  end

  @impl Phoenix.LiveView
  def mount(_params, _sesssion, socket) do
    {:ok, socket}
  end

  @impl Phoenix.LiveView
  def handle_params(%{"c" => c}, _url, socket), do: {:noreply, assign(socket, component: c)}
  def handle_params(_params, _url, socket), do: {:noreply, assign(socket, component: nil)}
end
