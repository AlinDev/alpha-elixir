defmodule Webui.Repo do
  use Ecto.Repo,
    otp_app: :webui,
    adapter: Ecto.Adapters.Postgres
end
