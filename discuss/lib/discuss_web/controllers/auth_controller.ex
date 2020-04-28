# Porque si se declara como DiscussWeb.AuthController (como los otros controladores) no funciona?
defmodule Discuss.AuthController do 
  use DiscussWeb, :controller
  plug Ueberauth
  alias Discuss.User
  alias Discuss.Repo
  # Requerido para poder usar Routes.topic_path en los redirects
  alias DiscussWeb.Router.Helpers, as: Routes

  #def callback(conn, params) do
  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, params) do
    user_params = %{token: auth.credentials.token, email: auth.info.email, provider: "github"}
    changeset = User.changeset(%User{}, user_params)
    signin(conn, changeset)
  end

  # Para cerrar la session, solo destru
  def signout(conn, _params) do
    conn
    |> configure_session(drop: true) # Destruimos cualquier atributo que este en la session para el usuario.
    |> redirect(to: Routes.topic_path(conn, :index))
  end

  defp signin(conn, changeset) do
    case insert_or_update_user(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome back!")
        |> put_session(:user_id, user.id) # Agregamos un atributo a la session
        |> redirect(to: Routes.topic_path(conn, :index))
      {:error, _reason} ->
        conn
        |> put_flash(:error, "Error signing in")
        |> redirect(to: Routes.topic_path(conn, :index))
    end
  end

  # defp: Funcion Privada, lo que significa que esta funcion no puede ser usada por ningun otro modulo
  # Con esta funcion verificaremos que solo existe en la tabla users el email 1 vez.
  defp insert_or_update_user(changeset) do

    case Repo.get_by(User, email: changeset.changes.email) do
      nil ->
        Repo.insert(changeset)
      user ->
        {:ok, user}
    end  
    
  end
  
end
