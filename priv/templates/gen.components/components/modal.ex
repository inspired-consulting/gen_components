defmodule <%= components_module %>.Modal do
  use <%= web_module %>, :component

  def modal(assigns) do
    assigns =
      assigns
      |> assign_new(:title, fn -> nil end)
      |> assign_new(:footer, fn -> nil end)
      |> assign_new(:class, fn -> "" end)

    attrs = assigns_to_attributes(assigns, [:class, :title, :footer, :"phx-target"])
    phx_target_assigns = if t = assigns[:"phx-target"], do: %{"phx-target": t}, else: %{}

    ~H"""
    <%%= if @shown? do %>
      <div class="modal fade show d-block" tabindex="-1" role="dialog" aria-modal="true">
        <div class={"modal-dialog #{@class}"} {attrs}>
          <div
            class="modal-content"
            phx-click-away={@close_event}
            phx-window-keydown={@close_event}
            phx-key="escape"
            {phx_target_assigns}
          >
            <%%= if @title do %>
              <div class="modal-header">
                <h5 class="modal-title"><%%= @title %></h5>
                <button type="button" class="btn-close" aria-label="Close" phx-click={@close_event} {phx_target_assigns}></button>
              </div>
            <%% end %>
            <div class="modal-body"><%%= render_slot(@inner_block) %></div>
            <%%= if @footer do %>
              <div class="modal-footer">
                <%%= render_slot(@footer) %>
              </div>
            <%% end %>
          </div>
        </div>
      </div>
      <div class="modal-backdrop fade show" />
    <%% end %>
    """
  end
end
