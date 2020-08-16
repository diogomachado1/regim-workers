defmodule ImportMassive.Repo do

  use Ecto.Repo,
    otp_app: :import_massive,
    adapter: Ecto.Adapters.Postgres
end
