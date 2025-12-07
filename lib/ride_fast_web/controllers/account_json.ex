defmodule RideFastWeb.AccountJSON do
  def auth(%{account: attrs, token: token}) do
    %{
      account: %{
        id: attrs.id,
        email: attrs.email,
        phone: attrs.phone
      },
      token: token
    }
  end

  def show(%{account: attrs}) do
    %{
      id: attrs.id,
      email: attrs.email,
      phone: attrs.phone
    }
  end
end
