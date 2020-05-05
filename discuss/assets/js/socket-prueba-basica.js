// Importamos la libreria para trabajar con Sockets en JS desde Phoenix
import {Socket} from "phoenix"

// Creamos una instancia de Socket Library
let socket = new Socket("/socket", {params: {token: window.userToken}})

// Nos conectamos hasta el lado del Servidor
socket.connect()

// Creamos una referencia a un canal especifico. Nos unimos al Chat comments en el servidor
// 
let channel = socket.channel("comments:1", {})

// Intentamos conectarnos al servidor via Socket (una sola vez por cliente)
channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

// Enviamos un mensaje al servidor via socket con el evento comment:add
document.querySelector('button').addEventListener('click', function() {
  channel.push('comment:hello', { id: "value2" });
});

// Exportamos el Socket que ha sido creado.
export default socket
