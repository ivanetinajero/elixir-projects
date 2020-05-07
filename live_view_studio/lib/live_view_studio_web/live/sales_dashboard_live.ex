# Para habilitar LiveView Debug en la consola del Navegador.
# liveSocket.enableDebug()

defmodule LiveViewStudioWeb.SalesDashboardLive do
  use LiveViewStudioWeb, :live_view

  # Modulo con logica de negocio
  # lib/live_view_studio/sales.ex
  alias LiveViewStudio.Sales

  def mount(_params, _session, socket) do
    # Verificamos si el cliente ya fue conectado al WebSocket
    if connected?(socket) do # El Process LiveView esta listo?
      # Iniciamos a enviar el evento llamado :tick a este mismo LiveView cada segundo
      # Similar a un CRON cada segundo (lanzar evento :tick automaticamente)
      :timer.send_interval(1000, self(), :tick)
    end

    socket = assign_stats(socket)

    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
    <h1>Sales Dashboard</h1>
    <div id="dashboard">
      <div class="stats">
        <div class="stat">
          <span class="value">
            <%= @new_orders %>
          </span>
          <span class="name">
            New Orders
          </span>
        </div>
        <div class="stat">
          <span class="value">
            $<%= @sales_amount %>
          </span>
          <span class="name">
            Sales Amount
          </span>
        </div>
        <div class="stat">
          <span class="value">
            <%= @satisfaction %>%
          </span>
          <span class="name">
            Satisfaction
          </span>
        </div>
      </div>

      <button phx-click="refresh">
        <img src="images/refresh.svg">
        Refresh
      </button>
    </div>
    """
  end

  # El boton Refresh actualiza el estado manualmente (accion ejecutada por el usuario)
  def handle_event("refresh", _, socket) do
    socket = assign_stats(socket)
    {:noreply, socket}
  end

  # handle info callbacks
  # Este es un evento interno (se llama automaticamente, sin la intervencion del usuario)
  # Solo 2 parametros:
  # Parametro 1: el nombre del evento (mensaje)
  # Parametro 2: el socket
  def handle_info(:tick, socket) do
    socket = assign_stats(socket)
    {:noreply, socket}
  end

  # Funcion para cambiar el estado de los datos en el Socket
  defp assign_stats(socket) do
    # La funcion assign regresa el socket actualizado
    assign(socket,
      new_orders: Sales.new_orders(),
      sales_amount: Sales.sales_amount(),
      satisfaction: Sales.satisfaction()
    )
  end
end
