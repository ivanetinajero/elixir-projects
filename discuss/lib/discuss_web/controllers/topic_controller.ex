defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller
  # Requerido para usar la funcion build_assoc
  import Ecto
  alias Discuss.Repo

  # para no tener que usar %Discuss.Topic{}
  alias Discuss.Topic
  # Requerido para poder usar Routes.topic_path en los redirects
  alias DiscussWeb.Router.Helpers, as: Routes

  #plug Discuss.Plugs.RequireAuth # Aplicamos este Plug antes de cada action solo para este Controlador
  # Aplicamos este Plug de tipo Module antes de los actions especificos solo en este Controlador
  plug Discuss.Plugs.RequireAuth when action in [:new, :create, :edit, :update, :delete]

  # Aqui estamos creando un Plug de tipo Function. Eso quiere decir que sera un Plug pero solo
  # funcionara en este controlador para los actions especificados.
  # En este caso es adecuado, porque este es un Plug que solo usaremos para este controlador y solo
  # se aplicara a unos actions determinados.
  # En este caso este Plug sera buscado en este controlador con el nombre de check_topic_owner
  plug :check_topic_owner when action in [:update, :edit, :delete]


  def index(conn, _params) do
    IO.puts "@@@@@@@"
    IO.inspect(conn.assigns)
    IO.puts "@@@@@@@"
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
    #changeset = Topic.changeset %Topic{}, topic

    changeset = conn.assigns.user # Recuperamos el objeto user del objeto conn
    # Referenciamos el usuario con el topic
    |> build_assoc(:topics) #Equivalente a: build_assoc(user, :topics)
    |> Topic.changeset(topic)

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

  # Este es un Function Plug definido solo para este controlador
  def check_topic_owner(conn, _params) do
    # del objeto conn, en concreto del atributo params (query URL) recuperamos el id.
    # Por ejemplo de la URL /topics/13/edit
    %{params: %{"id" => topic_id}} = conn

    # Sacamos de la BD el user_id del Topic y lo comparamos con el user_id que traemos en conn (algo similar a Session)
    if Repo.get(Topic, topic_id).user_id == conn.assigns.user.id do
      conn
    else
      conn
      |> put_flash(:error, "You cannot edit that")
      |> redirect(to: Routes.topic_path(conn, :index))
      |> halt() # detente aqui, no continues con el Action.
    end
  end

  # funcion para renderizar un topic determinado (con sus comentarios)
  def show(conn, %{"id" => topic_id}) do
    topic = Repo.get!(Topic, topic_id)
    render conn, "show.html", topic: topic
  end

end
