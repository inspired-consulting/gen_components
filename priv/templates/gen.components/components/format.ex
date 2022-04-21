defmodule <%= components_module %>.Format do
  use <%= web_module %>, :component

  def tel(assigns) do
    extra = assigns_to_attributes(assigns, [:number])

    ~H"""
    <a {extra} href={"tel:#{@number}"}><%%= @number %></a>
    """
  end

  def email(assigns) do
    extra = assigns_to_attributes(assigns, [:address])

    ~H"""
    <a {extra} href={"mailto:#{@address}"}><%%= @address %></a>
    """
  end

  def local_time(assigns) do
    extra = assigns_to_attributes(assigns, [:time])

    ~H"""
    <custom-local-time {extra} iso-time={@time} phx-update="ignore"><%%= @time %></custom-local-time>
    """
  end

  def local_date(assigns) do
    extra = assigns_to_attributes(assigns, [:date])

    ~H"""
    <custom-local-date {extra} iso-date={@date} phx-update="ignore"><%%= @date %></custom-local-date>
    """
  end

  def local_datetime(assigns) do
    assigns = assign_new(assigns, :format, fn -> "medium" end)
    extra = assigns_to_attributes(assigns, [:datetime, :format])

    ~H"""
    <custom-local-datetime {extra} iso-datetime={@datetime} format={@format} phx-update="ignore"><%%= @datetime %></custom-local-datetime>
    """
  end

  def local_number(assigns) do
    extra = assigns_to_attributes(assigns, [:number])

    ~H"""
    <custom-local-number {extra} value={@number} phx-update="ignore"><%%= @number %></custom-local-number>
    """
  end
end
