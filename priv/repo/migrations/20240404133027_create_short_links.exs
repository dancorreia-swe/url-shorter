defmodule UrlShorter.Repo.Migrations.CreateShortLinks do
  use Ecto.Migration

  def change do
    create table(:short_links) do
      add :key, :string, null: false
      add :url, :text, null: false
      add :hit_count, :integer, default: 0

      timestamps(type: :utc_datetime)
    end

    create index(:short_links, [:key], unique: true)
  end
end
