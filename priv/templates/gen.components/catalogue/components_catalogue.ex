defmodule <%= catalogue_module %> do
  use <%= web_module %>, :live_view

  alias <%= catalogue_module %>.Modals
  alias <%= catalogue_module %>.Paginations
  import <%= catalogue_module %>.Alerts
  import <%= catalogue_module %>.NavsTop
  import <%= catalogue_module %>.Icons

  @impl Phoenix.LiveView
  def render(assigns) do
    assigns = assign_new(assigns, :component, fn -> nil end)

    ~H"""
    <article style="display: flex; flex-direction: row; flex-wrap: wrap;">
      <h1 style="width: 100%;">gen.components</h1>
      <nav style="flex: 1;">
        <ul>
          <li><%%= live_patch "Alert", to: Routes.components_catalogue_path(@socket, :alerts) %></li>
          <li><%%= live_patch "Icon", to: Routes.components_catalogue_path(@socket, :icons) %></li>
          <li><%%= live_patch "Modal", to: Routes.components_catalogue_path(@socket, :modals) %></li>
          <li><%%= live_patch "Navs Top", to: Routes.components_catalogue_path(@socket, :navs_top) %></li>
          <li><%%= live_patch "Pagination", to: Routes.components_catalogue_path(@socket, :paginations) %></li>
        </ul>
      </nav>
      <main style="flex: 5;">
        <%%= case @live_action do %>
          <%% :alerts -> %><.alerts/>
          <%% :icons -> %><.icons/>
          <%% :modals -> %><.live_component module={Modals} id="modals"/>
          <%% :navs_top -> %><.navs_top/>
          <%% :paginations -> %><.live_component module={Paginations} id="paginations"/>
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

  defmacro catalogue_routes(path) do
    quote bind_quoted: [path: path] do
      import Phoenix.LiveView.Router, only: [live: 3, live_session: 2]

      live_session :catalogue do
        scope path do
          live "/", ComponentsCatalogueLive, :index
          live "/alerts", ComponentsCatalogueLive, :alerts
          live "/icons", ComponentsCatalogueLive, :icons
          live "/modals", ComponentsCatalogueLive, :modals
          live "/navs_top", ComponentsCatalogueLive, :navs_top
          live "/paginations", ComponentsCatalogueLive, :paginations
        end
      end
    end
  end
end
