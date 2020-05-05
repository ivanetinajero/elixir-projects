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
  def connect(_params, socket, _connect_info) do
    #IO.puts "¡¡¡¡¡ DiscussWeb.UserSocket.connect was called !!!!!"
    {:ok, socket}
  end
  
  def id(_socket), do: nil
end
