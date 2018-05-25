defmodule CoyoteWeb.Router do
  use CoyoteWeb, :router
  use ExAdmin.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :require_access do
    plug CoyoteWeb.AccessPlug
  end

  scope "/", CoyoteWeb do
    pipe_through :browser # Use the default browser stack
    get "/", PageController, :index
    post "/login", PageController, :login
  end

  # Other scopes may use custom stacks.
  scope "/api", CoyoteWeb do
    pipe_through :api
    resources "/topics", TopicController, except: [:new, :edit]
  end

  scope "/admin", ExAdmin do
    pipe_through [:browser, :require_access]
    admin_routes()
  end
end