defmodule RideFast.VehicleFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `RideFast.Vehicle` context.
  """

  @doc """
  Generate a vehicles.
  """
  def vehicles_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        active: true,
        color: "some color",
        model: "some model",
        plate: "some plate",
        seats: 42
      })

    {:ok, vehicles} = RideFast.Vehicle.create_vehicles(scope, attrs)
    vehicles
  end
end
