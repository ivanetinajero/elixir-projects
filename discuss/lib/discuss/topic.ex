defmodule Discuss.Topic do
  use Ecto.Schema
  import Ecto.Changeset

  # Indicamos que este modelo mapea a la tabla 'topics' con un campo llamado title
  schema "topics" do
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(topic, attrs \\ %{}) do
    topic
    |> cast(attrs, [:title])
    |> validate_required([:title])
    # Esta funcion al final regresa un tipo Ecto.Changeset (Esto es lo que se ira a la bd)
  end
end
