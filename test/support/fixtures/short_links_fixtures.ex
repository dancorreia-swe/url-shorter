defmodule UrlShorter.ShortLinksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `UrlShorter.ShortLinks` context.
  """

  @doc """
  Generate a short_link.
  """
  def short_link_fixture(attrs \\ %{}) do
    {:ok, short_link} =
      attrs
      |> Enum.into(%{
        hit_count: 42,
        key: "some key",
        url: "some url"
      })
      |> UrlShorter.ShortLinks.create_short_link()

    short_link
  end
end
