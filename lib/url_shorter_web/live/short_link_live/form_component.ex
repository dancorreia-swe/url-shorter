defmodule UrlShorterWeb.ShortLinkLive.FormComponent do
  use UrlShorterWeb, :live_component

  alias UrlShorter.ShortLinks

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage short_link records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="short_link-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:key]} type="text" label="Key" />
        <.input field={@form[:url]} type="text" label="Url" />
        <.input field={@form[:hit_count]} type="number" label="Hit count" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Short link</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{short_link: short_link} = assigns, socket) do
    changeset = ShortLinks.change_short_link(short_link)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"short_link" => short_link_params}, socket) do
    changeset =
      socket.assigns.short_link
      |> ShortLinks.change_short_link(short_link_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"short_link" => short_link_params}, socket) do
    save_short_link(socket, socket.assigns.action, short_link_params)
  end

  defp save_short_link(socket, :edit, short_link_params) do
    case ShortLinks.update_short_link(socket.assigns.short_link, short_link_params) do
      {:ok, short_link} ->
        notify_parent({:saved, short_link})

        {:noreply,
         socket
         |> put_flash(:info, "Short link updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_short_link(socket, :new, short_link_params) do
    case ShortLinks.create_short_link(short_link_params) do
      {:ok, short_link} ->
        notify_parent({:saved, short_link})

        {:noreply,
         socket
         |> put_flash(:info, "Short link created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
