defmodule RideFastWeb.DriverProfileJSON do
  alias RideFast.DriversProfiler.DriverProfile

  @doc """
  Renders a list of driver_profiles.
  """
  def index(%{driver_profiles: driver_profiles}) do
    %{data: for(driver_Profile <- driver_profiles, do: data(driver_Profile))}
  end

  @doc """
  Renders a single driver_Profile.
  """
  def show(%{driver_profile: driver_Profile}) do
    data(driver_Profile)
  end

  defp data(%DriverProfile{} = driver_Profile) do
    %{
      id: driver_Profile.id,
      license_number: driver_Profile.license_number,
      license_expiry: driver_Profile.license_expiry,
      background_check_ok: driver_Profile.background_check_ok
    }
  end
end
