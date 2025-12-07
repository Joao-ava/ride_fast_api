defmodule RideFastWeb.AccountController do
  use RideFastWeb, :controller

  alias RideFast.Accounts

  action_fallback RideFastWeb.FallbackController

  def register(conn, attrs) do
    with {:ok, account} <- Accounts.register(attrs) do
      conn
      |> render(:show, account: account)
    end
  end

  def login(conn, %{"email" => email, "password" => password}) do
    case Accounts.get_by_email_and_password(email, password) do
      {:ok, account, token} -> conn |> render(:auth, account: account, token: token)
      {:error, message} -> conn
        |> put_status(:bad_request)
        |> json(%{ message: message })
    end
  end
end
