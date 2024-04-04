defmodule UrlShorterWeb.Router do
  use UrlShorterWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {UrlShorterWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", UrlShorterWeb do
    pipe_through :browser

    get "/", PageController, :home

    live "/short_links", ShortLinkLive.Index, :index
    live "/short_links/new", ShortLinkLive.Index, :new
    live "/short_links/:id/edit", ShortLinkLive.Index, :edit

    live "/short_links/:id", ShortLinkLive.Show, :show
    live "/short_links/:id/show/edit", ShortLinkLive.Show, :edit

    get "/:key", ShortLinkRedirectController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", UrlShorterWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:url_shorter, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: UrlShorterWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
