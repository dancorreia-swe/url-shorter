defmodule UrlShorter.ShortLinks.ShortLink do
  use Ecto.Schema
  import Ecto.Changeset

  schema "short_links" do
    field :key, :string
    field :url, Fields.Url
    field :hit_count, :integer
    belongs_to :user, UrlShorter.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(short_link, attrs) do
    short_link
    |> cast(attrs, [:key, :url, :hit_count, :user_id])
    |> validate_required([:url])
  end
end
