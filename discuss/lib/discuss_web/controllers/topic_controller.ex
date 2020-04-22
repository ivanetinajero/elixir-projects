defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller
  alias Discuss.Repo

  # para no tener que usar %Discuss.Topic{}
  alias Discuss.Topic
  # Requerido para poder usar Routes.topic_path en los redirects
  alias DiscussWeb.Router.Helpers, as: Routes

  def index(conn, _params) do
    # Nos traemos todos los Topics de la BD para pasarlos al template
    topics = Repo.all(Discuss.Topic)
    render conn, "index.html", topics: topics
  end

  def new(conn, _params) do
    # topic = %Topic{} # Creamos un Topic
    # attrs = %{}
    # changeset = Topic.changeset(topic, attrs)

    #Ecto.Changeset<action: nil, changes: %{}, errors: [title: {"can't be blank", [validation: :required]}], data: #Discuss.Topic<>, valid?: false>
    changeset = Topic.changeset(%Topic{}, %{})
    render conn, "new.html", changeset: changeset

    #IO.puts "++++++"
    #IO.inspect(conn)
    #IO.puts "++++++"
    #IO.inspect(params)
    #IO.puts "++++++"
  end

  def create(conn, %{"topic" => topic}) do
    # changeset representa los cambios que queremos en la base de datos
    changeset = Topic.changeset %Topic{}, topic
    case Repo.insert changeset do

      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic Created") # El mensaje que mostraremos al usuario
        |> redirect(to: Routes.topic_path(conn, :index))
      {:error, changeset} ->
        render conn, "new.html", changeset: changeset

    end
  end

  def edit(conn, %{"id" => topic_id}) do # solo extraemos el id del Topic
    topic = Repo.get(Topic, topic_id) # buscar topic por topic_id
    changeset = Topic.changeset(topic)
    render conn, "edit.html", changeset: changeset, topic: topic
  end

  def update(conn, %{"id" => topic_id, "topic" => topic}) do

    old_topic = Repo.get(Topic, topic_id)
    changeset = Topic.changeset(old_topic, topic)

    case Repo.update(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic Updated")
        |> redirect(to: Routes.topic_path(conn, :index))
      {:error, changeset} ->
        render conn, "edit.html", changeset: changeset, topic: old_topic
    end

  end

  def delete(conn, %{"id" => topic_id}) do
    Repo.get!(Topic, topic_id) |> Repo.delete!

    conn
    |> put_flash(:info, "Topic Deleted")
    |> redirect(to: Routes.topic_path(conn, :index))
  end
end
