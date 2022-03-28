defmodule GenComponentsWeb.PageController do
  use GenComponentsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
