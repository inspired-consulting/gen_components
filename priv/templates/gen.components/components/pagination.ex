defmodule <%= web_module %>.<%= scoped %>.Pagination do
  use <%= web_module %>, :component

  def pagination_prev(assigns),
    do: ~H"""
    <%%= raw("&laquo;") %>
    """

  def pagination_next(assigns),
    do: ~H"""
    <%%= raw("&raquo;") %>
    """

  def pagination(assigns) do
    radius = 1
    %{page_number: page_number, total_pages: total_pages} = page = assigns[:page]

    page_nos =
      Enum.to_list(1..total_pages)
      |> map_to_shown_pages(radius, page)

    assigns =
      assigns
      |> assign(page_nos: page_nos)
      |> assign_new(:prev, fn -> nil end)
      |> assign_new(:next, fn -> nil end)
      |> assign_new(:class, fn -> "" end)

    attrs =
      assigns_to_attributes(assigns, [:class, :prev, :next, :page, :page_nos])

    ~H"""
    <nav class={@class} {attrs}>
      <ul class="pagination">
        <%%= if @prev do %>
          <li class={"page-item #{if @page.page_number <= 1, do: "disabled"}"}>
            <%%= render_slot(@prev, %{to_page: @page.page_number - 1, class: "page-link"}) %>
          </li>
        <%% end %>
        <%%= for page_no <- @page_nos do %>
          <%%= case page_no do %>
          <%% nil -> %>
            <li class="page-item disabled"><a class="page-link" href="#">…</a></li>
          <%% ^page_number  -> %>
            <li class="page-item active"><%%= render_slot(@inner_block, %{to_page: page_no, class: "page-link"}) %></li>
          <%% page_no -> %>
            <li class="page-item"><%%= render_slot(@inner_block, %{to_page: page_no, class: "page-link"}) %></li>
          <%% end %>
        <%% end %>
        <%%= if @next do %>
          <li class={"page-item #{if @page.page_number >= @page.total_pages, do: "disabled"}"}>
            <%%= render_slot(@next, %{to_page: @page.page_number + 1, class: "page-link"}) %>
          </li>
        <%% end %>
      </ul>
    </nav>
    """
  end

  defp map_to_shown_pages(page_nos, radius, %{total_pages: total_pages, page_number: page_number}) do
    border_range = 2 + 2 * radius
    range_from = min(page_number - radius, total_pages - border_range)
    range_to = max(page_number + radius, border_range + 1)

    Enum.map(page_nos, fn
      1 = e -> e
      ^total_pages = e -> e
      e when e in range_from..range_to -> e
      _ -> nil
    end)
    |> reject_double_nil()
  end

  defp reject_double_nil(page_nos) do
    Enum.zip(page_nos ++ [nil], [nil | page_nos])
    |> Enum.flat_map(fn
      {nil, nil} -> []
      {_, p} -> [p]
    end)
    |> Enum.drop(1)
  end
end
