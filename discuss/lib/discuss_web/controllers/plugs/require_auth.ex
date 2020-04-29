defmodule Discuss.Plugs.RequireAuth do
 
  # La necesitamos para poder usar la funcion halt()
  import Plug.Conn
  # Necesitamos este import porque aqui no estamos en un Controller y necesitamos acceso a: put_flash y redirect
  import Phoenix.Controller
  # Requerido para poder usar Routes.topic_path en los redirects
  alias DiscussWeb.Router.Helpers, as: Routes

  def init(_params) do
    IO.puts "Funcion init en Plug RequireAuth"
  end

  def call(conn, _params) do
    # si se cumple esta condicion (el usuario esta logueado) 
    if conn.assigns[:user] do 
      conn # Dejamos pasar este Plug (Interceptor). Sigue le flujo del Request
    else
      conn
      |> put_flash(:error, "You must be logged in.")
      |> redirect(to: Routes.topic_path(conn, :index))
      |> halt() # Con esta funcion le dicemos a Phoenix, ya terminamos aqui, no continua nada mas, regresa al usuario la respuesta
    end
  end

end    