defmodule RideFast.DriversFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `RideFast.Drivers` context.
  """

  @doc """
  Generate a driver.
  """
  def driver_fixture(attrs \\ %{}) do
    {:ok, driver} =
      attrs
      |> Enum.into(%{
        email: "some email",
        name: "some name",
        password_hash: "some password_hash",
        phone: "some phone",
        status: "some status"
      })
      |> RideFast.Drivers.create_driver()

    driver
  end
end
