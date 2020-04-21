defmodule Restapi.Repo do
  use Ecto.Repo,
    otp_app: :restapi,
    adapter: Ecto.Adapters.MyXQL
end
