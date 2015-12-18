defmodule HelloPhoenix.Router do
  use HelloPhoenix.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  #Прописываем новый источник данных
  #pipeline :review_checks do
  #  plug :ensure_authenticated_user
  #  plug :ensure_user_owns_review
  #end

  scope "/", HelloPhoenix do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/hello", HelloController, :index
    get "/hello/:messenger", HelloController, :show
    resources "/users", UserController
    resources "/posts", PostController #, only: [:index, :show] (если нужно только показывать)
    resources "/comments", CommentController #, except: [:delete] (если нужно исключить возможность удалить)
    resources "/reviews", ReviewController
    get "/images", ImageController, :index
    #вложенные ресурсы
    resources "/users", UserController do
      resources "/posts", PostController
    end
  end

  #Устанавливаем псевдонимы маршрутов для работы под admin
  scope "/admin", HelloPhoenix.Admin, as: :admin do
    pipe_through :browser

    resources "/reviews", ReviewController
    resources "/images", ImageController
    resources "/users", UserController
  end

  #После прописывания нового источника данных указываем сферу действия 
  #scope "/reviews", HelloPhoenix do
  #  pipe_through :review_checks
  #
  #  resources "/reviews", ReviewController
  #end

  #Пример вложения scope друг в друга
  scope "/api", HelloPhoenix.Api, as: :api do
    pipe_through :api

    scope "/v1", V1, as: :v1 do
      resources "/images",  ImageController
      resources "/reviews", ReviewController
      resources "/users",   UserController
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", HelloPhoenix do
  #   pipe_through :api
  # end
end
