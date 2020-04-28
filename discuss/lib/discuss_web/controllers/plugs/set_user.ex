defmodule Discuss.Plugs.SetUser do
  # Lo ocupamos por la funcion assign para modificar el un objeto conn. 
  import Plug.Conn
  # Lo ocupamos por la funcion get_session para recuperar datos de la session.
  import Phoenix.Controller 

  alias Discuss.Repo
  alias Discuss.User

  # Esta funcion es llamada una sola vez, cuando la aplicacion inicia
  def init(_params) do
    IO.puts "Funcion init en Plug SetUser"
  end

  # Esta funcion es llamada por cada Request en la app
  # _params es el valor retornado por la funcion init
  def call(conn, _params) do
    user_id = get_session(conn, :user_id) # Recuperamos un atributo a la session

    # Similar a un Case. Definimos varias condiciones, se van ir evaluando una a una de arriba hacia abajo
    # y la primera en ser verdadera sera la que se ejecutara
    cond do
      user = user_id && Repo.get(User, user_id) ->
        # La funcion assign recibe un objeto conn, lo modifica y al final regresa el objeto conn modificado.
        # Modificamos el objeto conn
        # Esto es como compartir el objeto user para toda la APP (incluida dentro de conn)
        # Despues de esto, cualquier objeto Plug tendra acceso al objeto user
        assign(conn, :user, user) 
      true ->
        # Si llegamos a esta condicion, asignamos, modificamos el objeto conn, y le asignamos
        # el objeto user como nulo.
        assign(conn, :user, nil)
    end
  end

end    