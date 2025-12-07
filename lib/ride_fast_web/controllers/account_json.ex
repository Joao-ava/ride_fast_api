defmodule RideFastWeb.AccountJSON do
  def show(%{account: attrs}) do
    %{
      id: attrs.id,
      email: attrs.email,
      phone: attrs.phone
    }
  end
end
