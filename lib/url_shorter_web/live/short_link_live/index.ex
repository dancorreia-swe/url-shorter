defmodule UrlShorterWeb.ShortLinkLive.Index do
  use UrlShorterWeb, :live_view

  alias UrlShorter.ShortLinks
  alias UrlShorter.ShortLinks.ShortLink

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :short_links, ShortLinks.list_short_links())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Short link")
    |> assign(:short_link, ShortLinks.get_short_link!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Short link")
    |> assign(:short_link, %ShortLink{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Short links")
    |> assign(:short_link, nil)
  end

  @impl true
  def handle_info({UrlShorterWeb.ShortLinkLive.FormComponent, {:saved, short_link}}, socket) do
    {:noreply, stream_insert(socket, :short_links, short_link)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    short_link = ShortLinks.get_short_link!(id)
    {:ok, _} = ShortLinks.delete_short_link(short_link)

    {:noreply, stream_delete(socket, :short_links, short_link)}
  end
end
