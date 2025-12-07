defmodule RideFastWeb.VehiclesController do
  use RideFastWeb, :controller

  alias RideFast.Vehicle
  alias RideFast.Drivers.Vehicles

  action_fallback RideFastWeb.FallbackController

  def index(conn, %{"driver_id" => driver_id}) do
    vehicles = Vehicle.list_vehicles(driver_id)
    render(conn, :index, vehicles: vehicles)
  end

  def create(conn, vehicles_params) do
    with {:ok, %Vehicles{} = vehicles} <- Vehicle.create_vehicles(conn.assigns.current_scope, vehicles_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/vehicles/#{vehicles}")
      |> render(:show, vehicles: vehicles)
    end
  end

  def show(conn, %{"id" => id}) do
    vehicles = Vehicle.get_vehicles!(id)
    render(conn, :show, vehicles: vehicles)
  end

  def update(conn, vehicles_params) do
    vehicles = Vehicle.get_vehicles!(vehicles_params["id"])

    with {:ok, %Vehicles{} = vehicles} <- Vehicle.update_vehicles(conn.assigns.current_scope, vehicles, vehicles_params) do
      render(conn, :show, vehicles: vehicles)
    end
  end

  def delete(conn, %{"id" => id}) do
    vehicles = Vehicle.get_vehicles!(id)

    with {:ok, %Vehicles{}} <- Vehicle.delete_vehicles(conn.assigns.current_scope, vehicles) do
      send_resp(conn, :no_content, "")
    end
  end
end
