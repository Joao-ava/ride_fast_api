defmodule RideFastWeb.UserController do
  use RideFastWeb, :controller

  alias RideFast.Accounts.User
  alias RideFast.Accounts

  action_fallback RideFastWeb.FallbackController

  # GET /api/Users
  def index(conn, params) do
    users = Accounts.list_users(params)
    render(conn, :index, users: users)
  end

  def show(conn, %{"id" => id}) do
    true = (
      (conn.assigns.current_scope.account.id == String.to_integer(id) && conn.assigns.current_scope.role == :user) ||
      conn.assigns.current_scope.role == :admin
    )
    user = Accounts.get_user!(id)
    render(conn, :show, user: user)
  end

  # POST /api/languages
  # def create(conn, language_params) do
  #   with {:ok, %Language{} = language} <- Languages.create_language(language_params) do
  #     conn
  #     |> put_status(:created)
  #     |> put_resp_header("location", ~p"/api/languages/#{language}")
  #     |> render(:show, language: language)
  #   end
  # end

end
