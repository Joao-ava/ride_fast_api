defmodule RideFastWeb.VehiclesJSON do
  alias RideFast.Drivers.Vehicles

  @doc """
  Renders a list of vehicles.
  """
  def index(%{vehicles: vehicles}) do
    %{data: for(vehicles <- vehicles, do: data(vehicles))}
  end

  @doc """
  Renders a single vehicles.
  """
  def show(%{vehicles: vehicles}) do
    %{data: data(vehicles)}
  end

  defp data(%Vehicles{} = vehicles) do
    %{
      id: vehicles.id,
      plate: vehicles.plate,
      model: vehicles.model,
      color: vehicles.color,
      seats: vehicles.seats,
      active: vehicles.active
    }
  end
end
