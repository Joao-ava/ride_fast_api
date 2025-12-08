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

  def update(conn, user_params) do
    true = (
      (conn.assigns.current_scope.account.id == String.to_integer(user_params["id"]) && conn.assigns.current_scope.role == :user) ||
      conn.assigns.current_scope.role == :admin
    )
    user = Accounts.get_user!(user_params["id"])

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, :show, user: user)
    end
  end

  def create(conn, user_params) do
    with {:ok, %User{} = user} <- Accounts.register_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/users/#{user.id}")
      |> render(:show, user: user)
    end
  end

  # DELETE /api/users/:id
  def delete(conn, %{"id" => id}) do
    true = (
      (conn.assigns.current_scope.account.id == String.to_integer(id) && conn.assigns.current_scope.role == :user) ||
      conn.assigns.current_scope.role == :admin
    )
    user = Accounts.get_user!(id)

    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
