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

  # rotas com autenticação
  scope "/api", RideFastWeb do
    pipe_through [:api, :fetch_current_scope_for_api_user]

    # Drivers
    resources "/drivers", DriverController do
      resources "/vehicles", VehiclesController, only: [:index, :create]
    end

    resources "/vehicles", VehiclesController, except: [:index, :create]

    # Languages
    resources "/languages", LanguageController

    # # Drivers <-> Languages (N:N)
    # get    "/drivers/:driver_id/languages", DriverLanguageController, :index
    # post   "/drivers/:driver_id/languages/:language_id", DriverLanguageController, :add
    # delete "/drivers/:driver_id/languages/:language_id", DriverLanguageController, :remove
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

  ## Authentication routes

  # scope "/", RideFastWeb do
  #   pipe_through [:browser, :redirect_if_user_is_authenticated]

  #   get "/users/register", UserRegistrationController, :new
  #   post "/users/register", UserRegistrationController, :create
  # end

  # scope "/", RideFastWeb do
  #   pipe_through [:browser, :require_authenticated_user]

  #   get "/users/settings", UserSettingsController, :edit
  #   put "/users/settings", UserSettingsController, :update
  #   get "/users/settings/confirm-email/:token", UserSettingsController, :confirm_email
  # end

  # scope "/", RideFastWeb do
  #   pipe_through [:browser]

  #   get "/users/log-in", UserSessionController, :new
  #   get "/users/log-in/:token", UserSessionController, :confirm
  #   post "/users/log-in", UserSessionController, :create
  #   delete "/users/log-out", UserSessionController, :delete
  # end
end
