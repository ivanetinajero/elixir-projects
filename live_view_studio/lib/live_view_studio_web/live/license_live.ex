# Para habilitar LiveView Debug en la consola del Navegador.
# liveSocket.enableDebug()

defmodule LiveViewStudioWeb.LicenseLive do
  use LiveViewStudioWeb, :live_view

  # Modulo con logica de negocio: calcular el monto total, por asientos seleccionados
  # lib/live_view_studio/licenses.ex
  alias LiveViewStudio.Licenses
  # Necesario para dar formato a numeros (number_to_currency)
  import Number.Currency

  def mount(_params, _session, socket) do
    socket = assign(socket, seats: 3, amount: Licenses.calculate(3))
    {:ok, socket}
  end

  def render(assigns) do
    # Declaramos un inline LiveView Template
    # phx-change="update" es un atributo HTML especifico de LiveView. update, es el nombre del evento que se enviara via socket
    ~L"""
    <h1>Team License</h1>
    <div id="license">
      <div class="card">
        <div class="content">
          <div class="seats">
            <img src="images/license.svg">
            <span>
              Your license is currently for
              <strong><%= @seats %></strong> seats.
            </span>
          </div>

          <form phx-change="update">
            <input type="range" min="1" max="10" name="seats" value="<%= @seats %>" />
          </form>

          <div class="amount">
            <%= number_to_currency(@amount) %>
          </div>
        </div>
      </div>
    </div>
    """
  end

  # handle event callbacks que responde al evento on
  # Esta funcion recibe 3 parametros:
  # Parametro 1: el nombre del evento
  # Parametro 2: metadata relacionada al evento, incluye form parameters.
  # Parametro 3: el socket que tiene el estado actual del LiveView Process
  # Aqui estamos sacando del 2 parametro, el valor del form input con nombre seats (viene como String)
  def handle_event("update", %{"seats" => seats}, socket) do
    seats = String.to_integer(seats)

    socket =
      assign(socket,
        seats: seats,
        amount: Licenses.calculate(seats)
      )

    {:noreply, socket}
  end
end
