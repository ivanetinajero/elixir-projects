# Este archivo user_socket.ex seria algo similar al archivo router.ex para HTTP
defmodule DiscussWeb.UserSocket do
  # Especificamos que este modulo debe comportarse como un Socket  
  use Phoenix.Socket

  ## Channels
  # El canal comments, sera implementado por el modulo CommentsChannel
  # La parte de comments:* seria algo similar a cuando mapeamos URLs (endpoints) a funciones en los controladores.
  # Algo como: 
  #   get "/comments/:id", CommentsController, :join, :handle_in
  channel "comments:*", DiscussWeb.CommentsChannel

  # Esta funcion es ejecutada cada que un NUEVO cliente JS se conecta a nuestro Phoenix Server via Socket.
  # Aqui es un buen lugar para poner configuracion global 
  # La variable socket es algo similar al objeto conn en un controlador.
  # La variable socket representa toda la informacion del Incoming Request/Outgoing Response
  # def connect(_params, socket, _connect_info) do
  def connect(%{"token" => token}, socket) do
    # Tenemos que verificar que el token sea valido...
    case Phoenix.Token.verify(socket, "key", token) do
      {:ok, user_id} ->
        # Si el token es valido, lo agregamos al Socket en los assigns (similar a conn en los Controladores)
        # Al tener el user_id en los assings del Socket, tendremos acceso al user_id desde los Channels
        {:ok, assign(socket, :user_id, user_id)} 
      {:error, _error} ->
        :error
    end
  end
  
  def id(_socket), do: nil
end
