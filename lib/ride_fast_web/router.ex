defmodule RideFastWeb.Router do
  use RideFastWeb, :router

  import RideFastWeb.UserAuth

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", RideFastWeb do
    pipe_through :api

    post "/auth/register", AccountController, :register
    post "/auth/login", AccountController, :login
  end



  # rotas admin
  scope "/api", RideFastWeb do
    pipe_through [:api, :fetch_current_scope_for_api_user, :required_admin]

    get "/users", UserController, :index
    post "/drivers", DriverController, :create

    # Languages
    resources "/languages", LanguageController
  end

  # rotas com autenticação
  scope "/api", RideFastWeb do
    pipe_through [:api, :fetch_current_scope_for_api_user]

    # Drivers
    resources "/drivers", DriverController, except: [:create]  do
      resources "/vehicles", VehiclesController, only: [:index, :create]
      get "/ratings", RatingsController, :index
      post "/profile", DriverProfileController, :create
      get "/profile", DriverProfileController, :show
      put "/profile", DriverProfileController, :update
      resources "/languages", DriverLanguageController
    end

    resources "/vehicles", VehiclesController, except: [:index, :create]
    resources "/rides", RidesController do
      post "/accept", RidesController, :accept
      post "/start", RidesController, :start
      post "/complete", RidesController, :complete
      get "/history", RidesController, :index_histories
      post "/cancel", RidesController, :delete
      post "/ratings", RatingsController, :create
    end

    resources "/users", UserController, excepts: [:index]
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:ride_fast, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: RideFastWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
