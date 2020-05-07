# Para habilitar LiveView Debug en la consola del Navegador.
# liveSocket.enableDebug()

defmodule LiveViewStudioWeb.LightLive do
  # Convertimos este modulo para que se comporte como un Liveview
  use LiveViewStudioWeb, :live_view

  # Esta es la primera funcion llamada via HTTP Request cuando accedemos a la ruta declarada en router.ex
  # Lleva 3 parametros:
  # Parametro 1: Son los datos que vienen en ela URL (query param and route params)
  # Parametro 2: Datos privados de la session
  # Parametro 3: El Liveview socket: se usa para especificar los datos iniciales de este Liveview
  # En esta funcion es donde pasamos valores iniciales al socket
  @spec mount(any, any, Phoenix.LiveView.Socket.t()) :: {:ok, Phoenix.LiveView.Socket.t()}
  def mount(_params, _session, socket) do
    socket = assign(socket, :brightness, 10) # La funcion socket regresa el socket actualizado
    IO.inspect socket
    {:ok, socket} # La funcion mount debe regresar una tupla
  end

  # La funcion render recibe solo un parametro assigns. Este es un map que viene del socket
  # Este mapa contiene el estado que hemos asignado desde el metodo mount
  # Esta funcion debe regresar contenido que sera renderizado. Puede ser HTML declarado aqui, o en otro archivo
  def render(assigns) do
    # Declaramos un inline LiveView Template
    # phx-click="off" es un atributo HTML especifico de LiveView. off, es el nombre del evento que se enviara via socket
    ~L"""
    <h1>Front Porch Light</h1>
    <div id="light">
      <div class="meter">
        <span style="width: <%= @brightness %>%">
          <%= @brightness %>%
        </span>
      </div>

      <button phx-click="off">
        <img src="images/light-off.svg">
      </button>

      <button phx-click="down">
        <img src="images/down.svg">
      </button>

      <button phx-click="up">
        <img src="images/up.svg">
      </button>

      <button phx-click="on">
        <img src="images/light-on.svg">
      </button>
    </div>
    """
  end

  # handle event callbacks que responde al evento on
  # Esta funcion recibe 3 parametros:
  # Parametro 1: el nombre del evento
  # Parametro 2: metadata relacionada al evento, incluye form parameters.
  # Parametro 3: el socket que tiene el estado actual del LiveView Process
  def handle_event("on", _, socket) do
    # Actualizamos el valor el atributo brightness cada vez que el boton on sea presionado
    socket = assign(socket, :brightness, 100)
    {:noreply, socket}
  end

  def handle_event("up", _, socket) do

    # Forma 1
    #brightness = socket.assigns.brightness + 10
    #socket = assign(socket, :brightness, brightness)

    # Forma 2 (shortcut). Cuando actualizamos un valor podemos usar la funcion update
    socket = update(socket, :brightness, &(&1 + 10))
    {:noreply, socket}
  end

  def handle_event("down", _, socket) do
    socket = update(socket, :brightness, &(&1 - 10))
    {:noreply, socket}
  end

  def handle_event("off", _, socket) do
    socket = assign(socket, :brightness, 0)
    {:noreply, socket}
  end
end
