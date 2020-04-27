# Porque si se declara como DiscussWeb.AuthController (como los otros controladores) no funciona?
defmodule Discuss.AuthController do 
  use DiscussWeb, :controller
  plug Ueberauth

  def callback(conn, params) do
    IO.inspect "+++++"
    IO.inspect conn.assigns
    IO.inspect "+++++"
    IO.inspect params
    IO.inspect "+++++"
    #user_params = %{token: auth.credentials.token, email: auth.info.email, provider: "github"}
    #changeset = User.changeset(%User{}, user_params)

    #signin(conn, changeset)
  end
  
end
