defmodule <%= catalogue_module %>.Modals do
  use <%= web_module %>, :live_component

  import <%= catalogue_module %>.Helpers
  import <%= components_module %>.Modal

  @impl Phoenix.LiveComponent
  def render(assigns) do
    ~H"""
    <div>
      <section style="margin: 1rem;">
        <h2>Pagination</h2>
        <button type="button" phx-click="open_modal_1" phx-target={@myself}>open</button>
        <.modal
          shown?={@show_modal_1}
          close_event="close_modal_1"
          phx-target={@myself}
        >
          <.lorem_ipsum paragraphs="1"/>
        </.modal>
      </section>
      <section style="border-top: 1px solid black; margin: 1rem;">
        <h2>Modal with title</h2>
        <button type="button" phx-click="open_modal_2" phx-target={@myself}>open</button>
        <.modal
          title="modal title"
          shown?={@show_modal_2}
          close_event="close_modal_2"
          phx-target={@myself}
        >
          <.lorem_ipsum paragraphs="1"/>
        </.modal>
      </section>
      <section style="border-top: 1px solid black; margin: 1rem;">
        <h2>Long Modal with footer</h2>
        <button type="button" phx-click="open_modal_3" phx-target={@myself}>open</button>
        <.modal
          title="modal title"
          shown?={@show_modal_3}
          close_event="close_modal_3"
          phx-target={@myself}
        >
          <.lorem_ipsum/>
          <:footer>footer</:footer>
        </.modal>
      </section>
      <section>
        <.placeholder height="100vh;" style="margin: 1rem;">
          High space to force a scrollable background.
        </.placeholder>
      </section>
    </div>
    """
  end

  @impl Phoenix.LiveComponent
  def update(_params, socket),
    do: {:ok, assign(socket, show_modal_1: false, show_modal_2: false, show_modal_3: false)}

  @impl Phoenix.LiveComponent
  def handle_event("open_modal_1", _params, socket) do
    {:noreply, assign(socket, show_modal_1: true)}
  end

  def handle_event("close_modal_1", _params, socket) do
    {:noreply, assign(socket, show_modal_1: false)}
  end

  @impl Phoenix.LiveComponent
  def handle_event("open_modal_2", _params, socket) do
    {:noreply, assign(socket, show_modal_2: true)}
  end

  def handle_event("close_modal_2", _params, socket) do
    {:noreply, assign(socket, show_modal_2: false)}
  end

  @impl Phoenix.LiveComponent
  def handle_event("open_modal_3", _params, socket) do
    {:noreply, assign(socket, show_modal_3: true)}
  end

  def handle_event("close_modal_3", _params, socket) do
    {:noreply, assign(socket, show_modal_3: false)}
  end
end
