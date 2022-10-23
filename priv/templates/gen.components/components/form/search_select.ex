defmodule <%= components_module %>.Form.SearchSelect do
  use <%= web_module %>, :component

  defp name(%{form: form, field: field}), do: input_name(form, field) <> "[]"
  defp name(%{name: name}), do: to_string(name)

  defp value(%{form: form, field: field}), do: input_value(form, field)
  defp value(%{value: value}), do: value

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
  def search_select(assigns) do
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
    <custom-searchable-select style="display: inline-block; position-relative">
      <custom-dropdown style="display: contents">
        <div data-dropdown-trigger aria-haspopup="true" aria-expanded="false" class="input-group">
          <%%= select(@form, @field, @options, selected: @value, class: "form-control", style: "z-index: -1;", "data-searchable-select-input": true, tabindex: -1) %>
          <button type="button" class="btn btn-outline-secondary dropdown-toggle" />
        </div>
        <div data-dropdown-expandable style="display: none; position: absolute; background-color: whitesmoke;" class="border rounded p-2">
          <custom-searchable-list style="display: contents;">
            <custom-selectable-list style="display: contents;" focus-class="bg-secondary">
              <input type="search" name="q" data-searchable-list-input class="w-100" />
              <hr />
              <ul class="p-0">
                <%%= for {label, value} <- @options do %>
                  <li item-value={value} id={"#{@id}-option-#{value}"} is="custom-selectable-list-item" data-searchable-list-item style="display: block; cursor: pointer;"><%%= label %></li>
                <%% end %>
              </ul>
            </custom-selectable-list>
          </custom-searchable-list>
        </div>
      </custom-dropdown>
    </custom-searchable-select>
    """
  end
end
