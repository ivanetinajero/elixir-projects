// Importamos la libreria para trabajar con Sockets en JS desde Phoenix
import {Socket} from "phoenix"

// Creamos una instancia de Socket Library
let socket = new Socket("/socket", {params: {token: window.userToken}})

// Nos conectamos hasta el lado del Servidor
socket.connect()

function createSocket(topicId){
  // Creamos una referencia a un canal especifico. Nos unimos al Chat comments en el servidor
  let channel = socket.channel("comments:" + topicId, {})

  // Intentamos conectarnos al servidor via Socket (una sola vez por cliente)
  channel.join()
    .receive("ok", resp => { console.log("Joined successfully", resp) })
    .receive("error", resp => { console.log("Unable to join", resp) })

  document.querySelector('#btnAdd').addEventListener('click', function() {
    const content = document.querySelector('#txtcomentario').value;
    // Enviamos un evento al servidor
    channel.push('comment:add', { content: content });
  });


};

// Agregamos nuestra funcion createSocket con alcance de Window
window.createSocket = createSocket;