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
end
