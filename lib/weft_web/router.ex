defmodule WeftWeb.Router do
  use WeftWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
    plug(:fetch_session)
  end

  scope "/api", WeftWeb do
    pipe_through(:api)

    post("/login", AuthController, :login)
    resources("/users", UserController, except: [:new, :edit])
    get("/users/:owner_id/posts", PostController, :index_by_owner)

    resources("/posts", PostController, except: [:new, :edit, :update])
  end
end
