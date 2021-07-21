defmodule Moneyman.Repo do
  use Ecto.Repo,
    otp_app: :moneyman,
    adapter: Ecto.Adapters.Postgres
end
