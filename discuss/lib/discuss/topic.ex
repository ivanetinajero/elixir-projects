defmodule Discuss.Topic do
  use Ecto.Schema
  import Ecto.Changeset

  # Indicamos que este modelo mapea a la tabla 'topics' con un campo llamado title
  schema "topics" do
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(topic, attrs) do
    topic
    |> cast(attrs, [:title])
    |> validate_required([:title])
  end
end
