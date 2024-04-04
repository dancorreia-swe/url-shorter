defmodule UrlShorter.Repo do
  use Ecto.Repo,
    otp_app: :url_shorter,
    adapter: Ecto.Adapters.Postgres
end
