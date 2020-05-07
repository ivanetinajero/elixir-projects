// Importamos la libreria para trabajar con Sockets en JS desde Phoenix
import {Socket} from "phoenix"

// Creamos una instancia de Socket Library.
// Le estamos pasando al Socket algunos parametros: params
let socket = new Socket("/socket", {params: {token: window.userToken}})

// Nos conectamos hasta el lado del Servidor
socket.connect()

function createSocket(topicId){
  // Creamos una referencia a un canal especifico. Nos unimos al Chat comments en el servidor
  let channel = socket.channel("comments:" + topicId, {})

  // Intentamos conectarnos al servidor via Socket (una sola vez por cliente)
  channel.join()
    .receive("ok", resp => { 
      //console.log("Joined successfully", resp.comments);      
      renderComments(resp.comments);
    })
    .receive("error", resp => { 
      console.log("Unable to join", resp); 
    });

  // Agregamos un EventListener en el Channel 
  // Implicitamente Phoenix le envia a la funcion renderComment un parametro de tipo Event (Socket Event Object)
  channel.on("comments:" + topicId +":new", renderComment);

  document.querySelector('#btnAdd').addEventListener('click', function() {
    const content = document.querySelector('#txtcomentario').value;
    // Enviamos un evento al servidor
    channel.push('comment:add', { content: content });
  });

};

function renderComments(comments) {  
  // Creamos un elemento <li> por cada comentario
  comments.forEach(function(c){          
    document.querySelector('.collection').appendChild(commentTemplate(c));
  });
}

// Esta funcion es lanzada por el EventListener y envia como parametro un Event, que es creado por Phoenix
function renderComment(event) {
  const renderedComment = commentTemplate(event.comment); 
  document.querySelector('.collection').appendChild(renderedComment);
}

/**
 * Esta funcion se encarga de regresar un elemento <li> por cada comment
 * @param {*} comment 
 */
function commentTemplate(comment) {
  let email = 'Anonymous';
  // Validamos por si un comment no tiene asociado un user
  if (comment.user) {
    email = comment.user.email;
  }

  var li = document.createElement('li');
  li.innerHTML = comment.content + "<div class='secondary-content'>"+ email +"</div>";
  li.className = 'collection-item';
  return li; 
}
  
// Agregamos nuestra funcion createSocket con alcance de Window
window.createSocket = createSocket;