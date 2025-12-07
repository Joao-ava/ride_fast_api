defmodule RideFast.DriversProfiler do
  @moduledoc """
  The DriversProfiler context.
  """

  import Ecto.Query, warn: false
  alias RideFast.Repo

  alias RideFast.DriversProfiler.DriverProfile
  alias RideFast.Accounts.Scope

  @doc """
  Subscribes to scoped notifications about any driver_Profile changes.

  The broadcasted messages match the pattern:

    * {:created, %DriverProfile{}}
    * {:updated, %DriverProfile{}}
    * {:deleted, %DriverProfile{}}

  """
  def subscribe_driver_profiles(%Scope{} = scope) do
    key = scope.account.id

    Phoenix.PubSub.subscribe(RideFast.PubSub, "user:#{key}:driver_profiles")
  end

  defp broadcast_driver_profile(%Scope{} = scope, message) do
    key = scope.account.id

    Phoenix.PubSub.broadcast(RideFast.PubSub, "user:#{key}:driver_profiles", message)
  end

  @doc """
  Returns the list of driver_profiles.

  ## Examples

      iex> list_driver_profiles(scope)
      [%DriverProfile{}, ...]

  """
  def list_driver_profiles(%Scope{} = scope) do
    Repo.all_by(DriverProfile, user_id: scope.account.id)
  end

  @doc """
  Gets a single driver_profile.

  Raises `Ecto.NoResultsError` if the Driver Profile does not exist.

  ## Examples

      iex> get_driver_profile!(scope, 123)
      %DriverProfile{}

      iex> get_driver_profile!(scope, 456)
      ** (Ecto.NoResultsError)

  """
  def get_driver_profile!(%Scope{} = _scope, id) do
    Repo.get_by!(DriverProfile, id: id)
  end

  def get_driver_profile_by_driver!(driver_id) do
    Repo.get_by!(DriverProfile, driver_id: driver_id)
  end

  @doc """
  Creates a driver_Profile.

  ## Examples

      iex> create_driver_Profile(scope, %{field: value})
      {:ok, %DriverProfile{}}

      iex> create_driver_Profile(scope, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_driver_profile(%Scope{} = scope, attrs) do
    with {:ok, driver_profile = %DriverProfile{}} <-
           %DriverProfile{}
           |> DriverProfile.changeset(attrs)
           |> Repo.insert() do
      broadcast_driver_profile(scope, {:created, driver_profile})
      {:ok, driver_profile}
    end
  end

  @doc """
  Updates a driver_Profile.

  ## Examples

      iex> update_driver_Profile(scope, driver_Profile, %{field: new_value})
      {:ok, %DriverProfile{}}

      iex> update_driver_Profile(scope, driver_Profile, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_driver_profile(%Scope{} = scope, %DriverProfile{} = driver_Profile, attrs) do
    with {:ok, driver_Profile = %DriverProfile{}} <-
           driver_Profile
           |> DriverProfile.changeset(attrs)
           |> Repo.update() do
      broadcast_driver_profile(scope, {:updated, driver_Profile})
      {:ok, driver_Profile}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking driver_Profile changes.

  ## Examples

      iex> change_driver_Profile(scope, driver_Profile)
      %Ecto.Changeset{data: %DriverProfile{}}

  """
  def change_driver_profile(%Scope{} = scope, %DriverProfile{} = driver_Profile, attrs \\ %{}) do
    DriverProfile.changeset(driver_Profile, attrs)
  end
end
