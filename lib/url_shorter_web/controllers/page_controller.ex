defmodule UrlShorterWeb.PageController do
  use UrlShorterWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    if conn.assigns[:current_user] do
      conn = redirect(conn, to: "/short_links")
      halt(conn)
    end

    render(conn, :home, layout: false)
  end
end
