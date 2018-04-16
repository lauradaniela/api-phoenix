defmodule Api13.Router do
  use Api13.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", Api13 do
    pipe_through :api
  end
end
