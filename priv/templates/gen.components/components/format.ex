defmodule <%= components_module %>.Format do
  use <%= web_module %>, :component

  attr :number, :any, doc: "integer or string"
  attr :extra, :global

  def tel(assigns) do
    ~H"""
    <a @extra id={gen_id()} href={"tel:#{@number}"}><%%= @number %></a>
    """
  end

  attr :address, :string, doc: "email address"
  attr :extra, :global

  def email(assigns) do
    ~H"""
    <a @extra id={gen_id()} href={"mailto:#{@address}"}><%%= @address %></a>
    """
  end

  attr :time, :any, doc: "Time or iso time string"
  attr :format, :string, default: "medium", values: ["medium", "short"]
  attr :extra, :global

  def local_time(assigns) do
    ~H"""
    <custom-local-time @extra id={gen_id()} iso-time={@time} phx-update="ignore"><%%= @time %></custom-local-time>
    """
  end

  attr :date, :any, doc: "Date or iso date string"
  attr :extra, :global

  def local_date(assigns) do
    ~H"""
    <custom-local-date @extra id={gen_id()} iso-date={@date} phx-update="ignore"><%%= @date %></custom-local-date>
    """
  end

  attr :datetime, :any, doc: "DateTime or iso datetime string"
  attr :format, :string, default: "medium", values: ["medium"]
  attr :extra, :global

  def local_datetime(assigns) do
    ~H"""
    <custom-local-datetime @extra id={gen_id()} iso-datetime={@datetime} format={@format} phx-update="ignore"><%%= @datetime %></custom-local-datetime>
    """
  end

  attr :number, :any, doc: "integer, float or Decimal"
  attr :extra, :global

  def local_number(assigns) do
    ~H"""
    <custom-local-number @extra id={gen_id()} value={@number} phx-update="ignore"><%%= @number %></custom-local-number>
    """
  end

  defp gen_id, do: Enum.random(10000000..99999999)
end
