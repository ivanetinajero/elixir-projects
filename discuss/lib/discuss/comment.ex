defmodule Discuss.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  # Esto significa lo siguiente. 
  # Cuando la libreria Jason (usada en Sockets) trate de convertir a JSON un tipo Comment
  # solo nos interesa el atributo content y user 
  # Los demas topic, timestamps ignoralos
  @derive {Jason.Encoder, only: [:content, :user]}

  # Indicamos que este modelo mapea a la tabla 'comments' 
  schema "comments" do
    field :content, :string
    belongs_to :user, Discuss.User
    belongs_to :topic, Discuss.Topic
    timestamps()
  end

  @doc false
  def changeset(comment, attrs \\ %{}) do
    comment
    |> cast(attrs, [:content])
    |> validate_required([:content])
    # Esta funcion al final regresa un tipo Ecto.Changeset (Esto es lo que se ira a la bd)
  end
end
