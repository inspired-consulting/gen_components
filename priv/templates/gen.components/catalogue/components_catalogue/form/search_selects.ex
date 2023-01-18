defmodule <%= catalogue_module %>.Form.SearchSelects do
  use <%= web_module %>, :live_component

  import <%= components_module %>.Form.SearchSelect
  import <%= components_module %>.Form.MultiSelect

  defmodule FormCs do
    alias Ecto.Changeset

    @types %{example_field: :string}
    @fields Map.keys(@types)

    def cast(params) do
      Changeset.cast({%{example_field: []}, @types}, params, @fields)
    end
  end

  defmodule PreferencesCs do
    alias Ecto.Changeset

    @types %{example_values: {:array, :string}}
    @fields Map.keys(@types)

    def cast(params) do
      Changeset.cast({%{example_values: []}, @types}, params, @fields)
    end
  end

  @impl Phoenix.LiveComponent
  def render(assigns) do
    ~H"""
    <div>
      <section style="margin: 1rem;">
        <h1>Searchable selects</h1>

        <.form :let={f} for={@preferences_cs} as={:preferences_form} action="#" phx-change="change-preferences" phx-target={@myself}>
          <h2>preferences</h2>
          <.multi_select_dropdown form={f} field={:example_values} options={@possible_options} />
        </.form>
        <button phx-click="set-4" phx-target={@myself}>set to 4</button>

        <.form :let={f} for={@form_cs} as={:example_form} action="#" phx-change="change" phx-target={@myself}>
          <h2>search_select</h2>
          <.search_select form={f} field={:example_field} options={@example_options} />
        </.form>

        <h2>current values</h2>
        <code>
          <%%= inspect(@current_values) %>
        </code>
      </section>
    </div>
    """
  end

  @impl Phoenix.LiveComponent
  def update(_params, socket) do
    form_cs = FormCs.cast(%{})
    preferences_cs = PreferencesCs.cast(%{example_values: Keyword.values(possible_options())})

    {:ok,
     socket
     |> assign(
       possible_options: possible_options(),
       example_options: example_options_from_preferences(preferences_cs),
       form_cs: form_cs,
       preferences_cs: preferences_cs,
       current_values: Ecto.Changeset.apply_changes(form_cs)
     )}
  end

  @impl Phoenix.LiveComponent
  def handle_event("set-4", _params, socket) do
    %{form_cs: form_cs} = socket.assigns
    form_cs = Ecto.Changeset.change(form_cs, example_field: "key-4")

    {:noreply,
     socket
     |> assign(
       form_cs: form_cs,
       current_values: Ecto.Changeset.apply_changes(form_cs)
     )}
  end

  def handle_event("change", %{"example_form" => values}, socket) do
    form_cs = FormCs.cast(values)

    {:noreply,
     socket
     |> assign(
       form_cs: form_cs,
       current_values: Ecto.Changeset.apply_changes(form_cs)
     )}
  end

  def handle_event("change-preferences", %{"preferences_form" => preferences}, socket) do
    preferences_cs = PreferencesCs.cast(preferences)

    {:noreply,
     socket
     |> assign(
       preferences_cs: preferences_cs,
       example_options: example_options_from_preferences(preferences_cs)
     )}
  end

  @possible_options for i <- 1..25, do: {"example label for key #{i}", "key-#{i}"}
  defp possible_options(), do: @possible_options

  defp example_options_from_preferences(preferences_cs) do
    prefs = Ecto.Changeset.get_field(preferences_cs, :example_values)

    for {label, key} <- possible_options(), Enum.member?(prefs, key) do
      {label, key}
    end
  end
end
