defmodule GenComponentsWeb.Router do
  use GenComponentsWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {GenComponentsWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", GenComponentsWeb do
    pipe_through :browser

    live "/catalogue", ComponentsCatalogueLive, :index

    get "/", PageController, :index
  end
end
