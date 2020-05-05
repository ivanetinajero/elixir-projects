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
        topic = Repo.get(Topic, topic_id)
        {:ok, %{}, assign(socket, :topic, topic)} # compartimos el objeto topic en todo el socket (similar a session)
        #{:ok, %{}, socket} 
        #{:ok, %{hey: "there!!!"}, socket} # Enviar de regreso al cliente (en formato JSON) estos datos ...
    end

    # Esta funcion recibe les mensajes(eventos) del cliente
    #def handle_in(name, message, socket) do
    def handle_in(name, %{"content" => content}, socket) do    
        # Recuperamos del socket (de los assigns), el objeto topic que fue agregado desde la funcion join
        topic = socket.assigns.topic 
        
        # Preparamos el changeset para enviarlo a la bd
        changeset = topic
        |> build_assoc(:comments)
        |> Comment.changeset(%{content: content})

        # Insertamos en bd el changeset
        case Repo.insert(changeset) do
            {:ok, comment} ->
                #broadcast!(socket, "comments:#{socket.assigns.topic.id}:new",
                #%{comment: comment}
                #)
                {:reply, :ok, socket}
            {:error, _reason} ->
                {:reply, {:error, %{errors: changeset}}, socket}
        end

        #{:reply, :ok, socket} # Enviar de regreso al cliente (en formato JSON) estos datos ...
    end

end    