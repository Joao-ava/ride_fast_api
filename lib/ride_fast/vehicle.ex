defmodule RideFast.Vehicle do
  @moduledoc """
  The Driver context.
  """

  import Ecto.Query, warn: false
  alias RideFast.Repo

  alias RideFast.Drivers.Vehicles
  alias RideFast.Accounts.Scope

  @doc """
  Subscribes to scoped notifications about any vehicles changes.

  The broadcasted messages match the pattern:

    * {:created, %Vehicles{}}
    * {:updated, %Vehicles{}}
    * {:deleted, %Vehicles{}}

  """
  def subscribe_vehicles(%Scope{} = scope) do
    key = scope.account.id

    Phoenix.PubSub.subscribe(RideFast.PubSub, "user:#{key}:vehicles")
  end

  defp broadcast_vehicles(%Scope{} = scope, message) do
    key = scope.account.id

    Phoenix.PubSub.broadcast(RideFast.PubSub, "user:#{key}:vehicles", message)
  end

  @doc """
  Returns the list of vehicles.

  ## Examples

      iex> list_vehicles(scope)
      [%Vehicles{}, ...]

  """
  def list_vehicles(driver_id) do
    Repo.all_by(Vehicles, driver_id: driver_id, active: true)
  end

  @doc """
  Gets a single vehicles.

  Raises `Ecto.NoResultsError` if the Vehicles does not exist.

  ## Examples

      iex> get_vehicles!(scope, 123)
      %Vehicles{}

      iex> get_vehicles!(scope, 456)
      ** (Ecto.NoResultsError)

  """
  def get_vehicles!(id) do
    Repo.get_by!(Vehicles, id: id)
  end

  @doc """
  Creates a vehicles.

  ## Examples

      iex> create_vehicles(scope, %{field: value})
      {:ok, %Vehicles{}}

      iex> create_vehicles(scope, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_vehicles(%Scope{} = scope, attrs) do
    with {:ok, vehicles = %Vehicles{}} <-
           %Vehicles{}
           |> Vehicles.changeset(attrs, scope)
           |> Repo.insert() do
      broadcast_vehicles(scope, {:created, vehicles})
      {:ok, vehicles}
    end
  end

  @doc """
  Updates a vehicles.

  ## Examples

      iex> update_vehicles(scope, vehicles, %{field: new_value})
      {:ok, %Vehicles{}}

      iex> update_vehicles(scope, vehicles, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_vehicles(%Scope{} = scope, %Vehicles{} = vehicles, attrs) do
    true = vehicles.driver_id == scope.account.id || scope.role == :admin

    with {:ok, vehicles = %Vehicles{}} <-
           vehicles
           |> Vehicles.changeset(attrs, scope)
           |> Repo.update() do
      broadcast_vehicles(scope, {:updated, vehicles})
      {:ok, vehicles}
    end
  end

  @doc """
  Deletes a vehicles.

  ## Examples

      iex> delete_vehicles(scope, vehicles)
      {:ok, %Vehicles{}}

      iex> delete_vehicles(scope, vehicles)
      {:error, %Ecto.Changeset{}}

  """
  def delete_vehicles(%Scope{} = scope, %Vehicles{} = vehicles) do
    true = vehicles.driver_id == scope.account.id || scope.role == :admin

    with {:ok, vehicles = %Vehicles{}} <-
           Repo.update(Vehicles.delete_changeset(vehicles)) do
      broadcast_vehicles(scope, {:deleted, vehicles})
      {:ok, vehicles}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking vehicles changes.

  ## Examples

      iex> change_vehicles(scope, vehicles)
      %Ecto.Changeset{data: %Vehicles{}}

  """
  def change_vehicles(%Scope{} = scope, %Vehicles{} = vehicles, attrs \\ %{}) do
    true = vehicles.driver_id == scope.account.id

    Vehicles.changeset(vehicles, attrs, scope)
  end
end
