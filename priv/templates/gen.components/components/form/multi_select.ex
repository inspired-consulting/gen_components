defmodule <%= components_module %>.Form.MultiSelect do
  use <%= web_module %>, :component

  alias Phoenix.LiveView.JS
  import <%= components_module %>.Icon

  defp close_select_dropdown(js \\ %JS{}, id) do
    js
    |> JS.remove_class("show", to: "##{id}.show")
    |> JS.remove_class("show", to: "##{id}.show .dropdown-menu")
    |> JS.set_attribute({"aria-expanded", "false"}, to: "##{id}.show .dropdown-menu")
  end

  defp toggle_select_dropdown(js \\ %JS{}, id) do
    js
    |> close_select_dropdown(id)
    |> JS.add_class("show", to: "##{id}:not(.show)")
    |> JS.add_class("show", to: "##{id}:not(.show) .dropdown-menu")
    |> JS.set_attribute({"aria-expanded", "true"}, to: "##{id}:not(.show) .dropdown-menu")
  end

  defp name(%{form: form, field: field}), do: input_name(form, field) <> "[]"
  defp name(%{name: name}), do: to_string(name)

  defp value(%{form: form, field: field}), do: Enum.reject(input_value(form, field) || [], &(&1 in ["", nil]))
  defp value(%{value: value}), do: Enum.reject(value, &(&1 in ["", nil]))

  defp id(%{form: form, field: field}, value), do: "#{input_id(form, field)}-#{value}"
  defp id(%{name: name}, value), do: "#{name}-#{value}"

  @doc """
  Combines `multi_select` and `multi_select_values` to a form element with a dropdown for the checkboxes.

  Needs either `form`-`field` or `name`-`value` attributes to be present.

  ## attributes
  * options: list of options to select. `[{"label 1", "value 1"} | ...]`
  * form: Phoenix.HTML.FormData
  * field: form field name
  * value: list of selected values. Not needed if form and field are given. `["value 1" | ...]`
  * name: name of the field. Not needed if form and field are given.
  ```
  """
  def multi_select_dropdown(assigns) do
    assigns = assign_new(assigns, :options, fn -> [] end)
    assigns = assign_new(assigns, :name, fn -> name(assigns) end)
    assigns = assign_new(assigns, :value, fn -> value(assigns) end)

    assigns =
      assign_new(assigns, :id, fn ->
        case assigns do
          %{form: form, field: field} -> input_id(form, field)
          %{name: name} -> to_string(name)
        end
      end)

    assigns = assign_new(assigns, :style, fn -> "" end)
    assigns = assign_new(assigns, :class, fn -> "" end)

    attrs = assigns_to_attributes(assigns, [:options, :name, :form, :field, :value, :style, :class])

    ~H"""
    <div {attrs} class={@class} style={@style}>
      <div class="input-group">
        <.multi_select_values name={@name} value={@value} options={@options} class="form-control" />
        <button phx-click={toggle_select_dropdown(@id)} class="btn btn-outline-secondary dropdown-toggle" type="button" id={"#{@id}-label"} aria-haspopup="true" aria-expanded="false"></button>
      </div>
      <div class="dropdown-menu p-1" aria-labelledby={"#{@id}-label"} phx-click-away={close_select_dropdown(@id)} phx-window-keydown={close_select_dropdown(@id)} phx-key="escape">
        <div style="max-height: 40vh; overflow-y: scroll;">
          <.multi_select name={@name} value={@value} options={@options} />
        </div>
      </div>
    </div>
    """
  end

  @doc """
  Generates an area with lables of the selected values of a `multi_select` form element.
  The labels are clickable to unselect the values in the corresponding `multi_select`.

  Needs either `form`-`field` or `name`-`value` attributes to be present.

  ## attributes
  * options: list of options to select. `[{"label 1", "value 1"} | ...]`
  * form: Phoenix.HTML.FormData
  * field: form field name
  * value: list of selected values. Not needed if form and field are given. `["value 1" | ...]`
  * name: name of the field. Not needed if form and field are given.
  ```
  """
  def multi_select_values(assigns) do
    assigns = assign_new(assigns, :options, fn -> [] end)
    assigns = assign_new(assigns, :value, fn -> value(assigns) end)
    assigns = assign_new(assigns, :style, fn -> "" end)
    assigns = assign_new(assigns, :class, fn -> "" end)

    ~H"""
    <div class={"bg-light border border-1 rounded d-flex #{@class}"} style={"flex-wrap: wrap; align-content: center; align-items: center; min-height: 2rem; padding: 0.1rem 0.1rem; #{@style}"}>
      <%%= for {label, value} <- @options, value in @value do %>
        <label for={id(assigns, value)} class="badge badge-secondary text-bg-secondary bg-secondary" style="cursor: pointer; margin: 0.1rem 0.1rem;">&times;&nbsp;<%%= label %></label>
      <%% end %>
    </div>
    """
  end

  @doc """
  Generates a list of checkboxes, that submit a list of values.

  Needs either `form`-`field` or `name`-`value` attributes to be present.

  ## attributes
  * options: list of options to select. `[{"label 1", "value 1"} | ...]`
  * form: Phoenix.HTML.FormData
  * field: form field name
  * value: list of selected values. Not needed if form and field are given. `["value 1" | ...]`
  * name: name of the field. Not needed if form and field are given.

  ## empty list

  To determin, that no element of the list is checked, an empty string will be
  submitted as a first list element. This "empty element" will be filtered out
  when using an Ecto.Changeset for casting. Without changeset you have to handle it by your own:

  ```elixir
  defmodule FormCs do
    alias Ecto.Changeset

    @types %{example_field: {:array, :string}}
    @fields Map.keys(@types)

    def cast(params) do
      Changeset.cast({%{example_field: []}, @types}, params, @fields)
    end
  end

  iex(9)> FormCs.cast(%{example_field: ["", "first", "second"]}).changes
  %{example_field: ["first", "second"]},
  ```
  """
  def multi_select(assigns) do
    assigns = assign_new(assigns, :options, fn -> [] end)
    assigns = assign_new(assigns, :name, fn -> name(assigns) end)
    assigns = assign_new(assigns, :value, fn -> value(assigns) end)
    assigns = assign_new(assigns, :style, fn -> "" end)
    assigns = assign_new(assigns, :class, fn -> "" end)

    attrs = assigns_to_attributes(assigns, [:options, :name, :form, :field, :value, :style, :class])

    ~H"""
    <div {attrs} class={@class} style={"padding: 0.1rem 0.1rem; #{@style}"}>
      <input type="hidden" name={@name} value="" />
      <%%= for {label, value} <- @options do %>
        <.multi_check_start name={@name} checked_value={value} values={@value} disabled={false} id={id(assigns, value)}><%%= label %></.multi_check_start>
      <%% end %>
    </div>
    """
  end

  # checkbox, that generates an array of values with a label at the start (RTL aware).
  defp multi_check_start(assigns) do
    ~H"""
    <div class="form-check">
      <label class="form-check-label">
        <%%= render_slot(@inner_block) %>
        <.multi_checkbox name={@name} values={@values} checked_value={@checked_value} disabled={@disabled} id={@id} />
        <span class="form-check-sign">
          <span class="check" />
        </span>
      </label>
    </div>
    """
  end

  # checkbox, that generates an array of values.
  defp multi_checkbox(assigns) do
    assigns = assign_new(assigns, :disabled, fn -> false end)

    attrs = assigns_to_attributes(assigns, [:class, :form, :field, :checked_value, :values])

    # We html escape all values to be sure we are comparing
    # apples to apples. After all we may have true in the data
    # but "true" in the params and both need to match.
    values = Enum.map(assigns.values, &html_escape/1)
    checked_value = html_escape(assigns.checked_value)

    ~H"""
    <input type="checkbox" class="form-check-input" checked={checked_value in values} value={checked_value} {attrs} />
    """
  end
end
