defmodule RideFastWeb.UserJSON do
  def index(%{users: users}) do
    %{data: for(user <- users, do: data(user))}
  end

  def show(%{user: attrs}) do
    data(attrs)
  end

  defp data(attrs) do
    %{
      id: attrs.id,
      email: attrs.email,
      phone: attrs.phone
    }
  end
end
