defmodule RideFast.Ride do
  @moduledoc """
  The Ride context.
  """

  import Ecto.Query, warn: false
  alias RideFast.Ride.RideHistory
  alias RideFast.Repo

  alias RideFast.Ride.Rides
  alias RideFast.Accounts.Scope

  @doc """
  Subscribes to scoped notifications about any rides changes.

  The broadcasted messages match the pattern:

    * {:created, %Rides{}}
    * {:updated, %Rides{}}
    * {:deleted, %Rides{}}

  """
  def subscribe_rides(%Scope{} = scope) do
    key = scope.account.id

    Phoenix.PubSub.subscribe(RideFast.PubSub, "user:#{key}:rides")
  end

  defp broadcast_rides(%Scope{} = scope, message) do
    key = scope.account.id

    Phoenix.PubSub.broadcast(RideFast.PubSub, "user:#{key}:rides", message)
  end

  @doc """
  Returns the list of rides.

  ## Examples

      iex> list_rides(scope)
      [%Rides{}, ...]

  """
  def list_rides(filters \\ %{}) do
    Repo.all(Rides.list_filter(filters))
    |> Repo.preload([:driver, :user])
  end

  def list_history(rides_id) do
    Repo.all_by(RideHistory, rides_id: rides_id)
  end

  @doc """
  Gets a single rides.

  Raises `Ecto.NoResultsError` if the Rides does not exist.

  ## Examples

      iex> get_rides!(scope, 123)
      %Rides{}

      iex> get_rides!(scope, 456)
      ** (Ecto.NoResultsError)

  """
  def get_rides!(%Scope{} = _scope, id) do
    Rides
    |> Repo.get_by!(id: id)
    |> Repo.preload([:user, :driver, :vehicle, :histories])
  end

  @doc """
  Creates a rides.

  ## Examples

      iex> create_rides(scope, %{field: value})
      {:ok, %Rides{}}

      iex> create_rides(scope, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_rides(%Scope{} = scope, attrs) do
    with {:ok, rides = %Rides{}} <-
           %Rides{}
           |> Rides.changeset(attrs |> Map.put(:price_estimate, 20), scope)
           |> Repo.insert() do
      broadcast_rides(scope, {:created, rides})
      {:ok, rides |> Repo.preload(:user)}
    end
  end

  @doc """
  Deletes a rides.

  ## Examples

      iex> delete_rides(scope, rides)
      {:ok, %Rides{}}

      iex> delete_rides(scope, rides)
      {:error, %Ecto.Changeset{}}

  """
  def delete_rides(%Scope{} = scope, %Rides{} = rides, attrs) do
    true = rides.user_id == scope.account.id || rides.driver_id == scope.account.id || scope.role == :admin
    true = rides.status != "CANCELADA"

    with {:ok, to = %Rides{}} <-
           Repo.update(rides |> Rides.cancel(attrs)) do
      broadcast_rides(scope, {:deleted, to})
      create_history(scope, to, rides)
      {:ok, rides}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking rides changes.

  ## Examples

      iex> change_rides(scope, rides)
      %Ecto.Changeset{data: %Rides{}}

  """
  def change_rides(%Scope{} = scope, %Rides{} = rides, attrs \\ %{}) do
    true = rides.user_id == scope.account.id

    Rides.changeset(rides, attrs, scope)
  end

  def accept(%Scope{} = scope, %Rides{} = ride, vehicle_id) do
    true = ride.status == "SOLICITADA" && scope.role == :driver
    {:ok, to} = Rides.accept(ride, %{vehicle_id: vehicle_id, driver_id: scope.account.id})
    |> Repo.update()
    create_history(scope, to, ride)
    {:ok, to |> Repo.preload([:user, :driver, :vehicle, :histories])}
  end

  def start(%Scope{} = scope, %Rides{} = ride) do
    true = ride.status == "ACEITA" && scope.role == :driver
    {:ok, to} = Rides.start(ride)
    |> Repo.update()
    create_history(scope, to, ride)
    {:ok, to |> Repo.preload([:user, :driver, :vehicle, :histories])}
  end

  def complete(%Scope{} = scope, %Rides{} = ride, attrs) do
    true = ride.status == "EM_ANDAMENTO" && scope.role == :driver
    {:ok, to} = Rides.complete(ride, attrs)
    |> Repo.update()
    create_history(scope, to, ride)
    {:ok, to |> Repo.preload([:user, :driver, :vehicle, :histories])}
  end

  def create_history(%Scope{} = scope, to, old) do
    data = %{from_state: old.status, to_state: to.status, rides_id: to.id}
    history = case scope.role do
      :driver -> Map.put(data, :drivers_id, scope.account.id)
      _ -> Map.put(data, :users_id, scope.account.id)
    end
    %RideHistory{}
    |> RideHistory.changeset(history)
    |> Repo.insert()
  end
end
