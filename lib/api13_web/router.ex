defmodule Api13Web.Router do
  use Api13Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/v1", Api13Web do
    pipe_through :api

    get "/users", UserController, :index
  end
end
