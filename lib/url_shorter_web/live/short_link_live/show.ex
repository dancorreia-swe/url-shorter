defmodule UrlShorterWeb.ShortLinkLive.Show do
  use UrlShorterWeb, :live_view

  alias UrlShorter.ShortLinks

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:short_link, ShortLinks.get_short_link!(id))}
  end

  defp page_title(:show), do: "Show Short link"
  defp page_title(:edit), do: "Edit Short link"
end
