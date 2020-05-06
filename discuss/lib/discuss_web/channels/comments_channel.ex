defmodule DiscussWeb.CommentsChannel do
    # Especificamos que este modulo debe comportarse como un Channel
    use DiscussWeb, :channel
    # Requerido para usar la funcion build_assoc
    import Ecto
    alias Discuss.{Topic, Comment} # Varios alias en una sola linea
    alias Discuss.Repo

    # Esta funcion es ejecutada cada que un NUEVO cliente JS se conecta a nuestro Socket CommentsChannel. 
    # La firma de este metodo esta definida:
    #   El primer parametro es como la URL que fue llamada desde JS
    #   El segundo parametro son los parametros que vienen desde el cliente
    #   El tercer parametro es socket (similar a conn en un Controlador)
    #def join(name, _params, socket) do
    #    {:ok, %{hey: "there!!!"}, socket} # Enviar de regreso al cliente (en formato JSON) estos datos ...
    #end

    # El primer parametro "comments:" <> topic_id significa
    # asigna a la variable topic_id todo lo que venga despues de comments:
    # En este caso seria el idTopic
    def join("comments:" <> topic_id, _params, socket) do
        topic_id = String.to_integer(topic_id) # convertimos el topic_id a numero porque viene como String
        
        # Cargamos registros asociados con el Topic (en este caso los comentarios)
        topic = Topic
        |> Repo.get(topic_id) # busca un Topic con este id
        # Si encuentras el Topic, recupera tambien sus comentarios asociados
        #|> Repo.preload(:comments) # para cargar solo los comments 
        # (Nested Association: Topic -> Comments -> User)       
        |> Repo.preload(comments: [:user]) # Carga todos los comments para este Topic y despues por cada comment, carga la asociacion del user

        {:ok, %{comments: topic.comments}, assign(socket, :topic, topic)} # compartimos el objeto topic en todo el socket (similar a session)
        
        #{:ok, %{}, socket} 
        #{:ok, %{hey: "there!!!"}, socket} # Enviar de regreso al cliente (en formato JSON) estos datos ...
    end

    # Esta funcion recibe les mensajes(eventos) del cliente
    #def handle_in(name, message, socket) do
    def handle_in(name, %{"content" => content}, socket) do    
        # Recuperamos del socket (de los assigns), el objeto topic que fue agregado desde la funcion join
        topic = socket.assigns.topic
        # Recueramos de los assigns del Socket en user_id (fue agregado en la funcion connect en user_socket.ex)
        user_id = socket.assigns.user_id
         
        # Preparamos el changeset para enviarlo a la bd
        changeset = topic
        # Por defecto la funcion build_assoc solo puede referencias a una relacion (pero aqui necesitamos dos: topic, user)
        |> build_assoc(:comments, user_id: user_id) # Ocupamos 2 referencias. La segunda la hacemos como mas manual
        |> Comment.changeset(%{content: content})

        # Insertamos en bd el changeset
        case Repo.insert(changeset) do
            {:ok, comment} ->
                # Enviamos una notificacion (broadcast) a todos los usuarios conectados al canal para que automaticamente
                # en sus navegadores vean el nuevo comentario.
                # Parametros:
                #   Parametro 1: el socket
                #   Parametro 2: el nombre del evento (comments:idTopic:new) que sera enviado a cualquier cliente conectado al canal     
                #   Parametro 3: Los datos que seran adjuntados con el evento a ser enviado.
                broadcast!(socket, "comments:#{socket.assigns.topic.id}:new",%{comment: comment})
                {:reply, :ok, socket}
            {:error, _reason} ->
                {:reply, {:error, %{errors: changeset}}, socket}
        end
        #{:reply, :ok, socket} # Enviar de regreso al cliente (en formato JSON) estos datos ...
    end

end    