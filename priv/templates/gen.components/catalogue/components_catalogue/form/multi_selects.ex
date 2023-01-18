defmodule <%= catalogue_module %>.Form.MultiSelects do
  use <%= web_module %>, :live_component

  import <%= components_module %>.Form.MultiSelect

  defmodule FormCs do
    alias Ecto.Changeset

    @types %{example_field: {:array, :string}}
    @fields Map.keys(@types)

    def cast(params) do
      Changeset.cast({%{example_field: []}, @types}, params, @fields)
    end
  end

  @impl Phoenix.LiveComponent
  def render(assigns) do
    ~H"""
    <div>
      <section style="margin: 1rem;">
        <h1>Multi selects</h1>
        <code>
          <%%= inspect(@current_values) %>
        </code>
      </section>
      <section style="margin: 1rem;">
        <h2>multi_select_dropdown</h2>
        <.form :let={f} for={@form_cs} as={:example_form} action="#" phx-change="change" phx-target={@myself}>
          <.multi_select_dropdown form={f} field={:example_field} options={@example_options} />
        </.form>
      </section>
      <section style="margin: 1rem;">
        <h2>multi_select_values</h2>
        <.form :let={f} for={@form_cs} as={:example_form} action="#" phx-change="change" phx-target={@myself}>
          <.multi_select_values form={f} field={:example_field} options={@example_options} />
        </.form>
      </section>
      <section style="margin: 1rem;">
        <h2>multi_select</h2>
        <.form :let={f} for={@form_cs} as={:example_form} action="#" phx-change="change" phx-target={@myself}>
          <.multi_select form={f} field={:example_field} options={@example_options} />
        </.form>
      </section>
    </div>
    """
  end

  @impl Phoenix.LiveComponent
  def update(_params, socket) do
    form_cs = FormCs.cast(%{})

    {:ok,
     socket
     |> assign(
       example_options: example_options(),
       form_cs: form_cs,
       current_values: Ecto.Changeset.apply_changes(form_cs)
     )}
  end

  @impl Phoenix.LiveComponent
  def handle_event("change", %{"example_form" => values}, socket) do
    form_cs = FormCs.cast(values)

    {:noreply,
     socket
     |> assign(
       form_cs: form_cs,
       current_values: Ecto.Changeset.apply_changes(form_cs)
     )}
  end

  defp example_options() do
    for i <- 1..25 do
      {"example label for key #{i}", "key-#{i}"}
    end
  end
end
