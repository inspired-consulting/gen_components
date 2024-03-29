defmodule ComponentsDemoWeb.Router do
  use ComponentsDemoWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {ComponentsDemoWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ComponentsDemoWeb do
    pipe_through :browser

    import ComponentsDemoWeb.ComponentsCatalogueLive
    catalogue_routes("/catalogue")

    get "/", PageController, :index
  end

  scope "/api", ComponentsDemoWeb do
    pipe_through :api
    post "/upload", UploadController, :create
  end
end
