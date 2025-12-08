defmodule RideFastWeb.DriverController do
  use RideFastWeb, :controller

  alias RideFast.Drivers
  alias RideFast.Drivers.Driver
  alias RideFast.Accounts

  action_fallback RideFastWeb.FallbackController

  def index(conn, _params) do
    drivers = Drivers.list_drivers()
    render(conn, :index, drivers: drivers)
  end

  def create(conn, driver_params) do
    with {:ok, %Driver{} = driver} <- Accounts.register_driver(driver_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/drivers/#{driver}")
      |> render(:show, driver: driver)
    end
  end

  def show(conn, %{"id" => id}) do
    driver = Drivers.get_driver!(id)
    render(conn, :show, driver: driver)
  end

  def update(conn, driver_params) do
    driver = Drivers.get_driver!(driver_params["id"])

    with {:ok, %Driver{} = driver} <- Drivers.update_driver(driver, driver_params) do
      render(conn, :show, driver: driver)
    end
  end

  def delete(conn, %{"id" => id}) do
    driver = Drivers.get_driver!(id)

    with {:ok, %Driver{}} <- Drivers.delete_driver(driver) do
      send_resp(conn, :no_content, "")
    end
  end
end
