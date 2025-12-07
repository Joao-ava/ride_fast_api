defmodule RideFastWeb.DriverProfileController do
  use RideFastWeb, :controller

  alias RideFast.DriversProfiler
  alias RideFast.DriversProfiler.DriverProfile

  action_fallback RideFastWeb.FallbackController

  def create(conn, driver_profile_params) do
    with {:ok, %DriverProfile{} = driver_profile} <- DriversProfiler.create_driver_profile(conn.assigns.current_scope, driver_profile_params) do
      conn
      |> put_status(:created)
      |> render(:show, driver_profile: driver_profile)
    end
  end

  def show(conn, %{"driver_id" => id}) do
    {driver_id, _} = Integer.parse(id)
    driver_profile = DriversProfiler.get_driver_profile_by_driver!(driver_id)
    render(conn, :show, driver_profile: driver_profile)
  end

  def update(conn, driver_profile_params) do
    {driver_id, _} = Integer.parse(driver_profile_params["driver_id"])
    driver_profile = DriversProfiler.get_driver_profile_by_driver!(driver_id)

    with {:ok, %DriverProfile{} = driver_profile} <- DriversProfiler.update_driver_profile(conn.assigns.current_scope, driver_profile, driver_profile_params) do
      render(conn, :show, driver_profile: driver_profile)
    end
  end
end
