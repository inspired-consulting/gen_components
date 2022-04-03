defmodule ComponentsDemoWeb.PageController do
  use ComponentsDemoWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
