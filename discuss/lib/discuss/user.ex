defmodule Discuss.User do
  use Ecto.Schema
  import Ecto.Changeset

  # Esto significa lo siguiente. 
  # Cuando la libreria Jason (usada en Sockets) trate de convertir a JSON un tipo User
  # solo nos interesa el atributo email 
  # Los demas provider, token, timestamps, etc. ignoralos
  @derive {Jason.Encoder, only: [:email]}

  schema "users" do
    field :email, :string
    field :provider, :string
    field :token, :string
    # Definimos una relacion (un usuario tiene muchos topics)
    has_many :topics, Discuss.Topic
    has_many :comments, Discuss.Comment
    timestamps()
  end

  @doc false
  def changeset(user, attrs \\ %{}) do
    user
    |> cast(attrs, [:email, :provider, :token])
    |> validate_required([:email, :provider, :token])
  end
end
