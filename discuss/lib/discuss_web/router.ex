defmodule DiscussWeb.Router do
  use DiscussWeb, :router

  # Algo similar a Interceptores/Filtros (logica antes de ejecutar el Request)
  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    # Cada que el usuario haga un Request, pasara por la logica de este Module Plug (Interceptor)
    plug Discuss.Plugs.SetUser

  end

  pipeline :api do
    plug :accepts, ["json"]
  end

        #PREFIX
  scope "/", DiscussWeb do
    pipe_through :browser # Use the default browser stack

    #get "/", PageController, :index
    get "/", TopicController, :index
    get "/topics/new", TopicController, :new
    post "/topics", TopicController, :create
    get "/topics/:id/edit", TopicController, :edit
    put "/topics/:id", TopicController, :update
    delete "/topics/:id", TopicController, :delete

  end
        #PREFIX  (rutas para Ueberauth)
  scope "/auth", Discuss do
    pipe_through :browser # Use the default browser stack

    # tiene que ir al principio. ¿Porque?
    get "/signout", AuthController, :signout
    get "/:provider", AuthController, :request # La funcion request es creada por Ueberauth en el controller
    get "/:provider/callback", AuthController, :callback     
    
  end

  # Other scopes may use custom stacks.
  # scope "/api", DiscussWeb do
  #   pipe_through :api
  # end
end
