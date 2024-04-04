defmodule UrlShorter.ShortLinks.ShortLink do
  use Ecto.Schema
  import Ecto.Changeset

  schema "short_links" do
    field :key, :string
    field :url, Fields.Url
    field :hit_count, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(short_link, attrs) do
    short_link
    |> cast(attrs, [:key, :url, :hit_count])
    |> validate_required([:url])
  end
end
