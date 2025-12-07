defmodule RideFast.Rating do
  @moduledoc """
  The Rating context.
  """

  import Ecto.Query, warn: false
  alias RideFast.Repo

  alias RideFast.Rating.Ratings
  alias RideFast.Accounts.Scope
  alias RideFast.Ride.Rides

  @doc """
  Subscribes to scoped notifications about any ratings changes.

  The broadcasted messages match the pattern:

    * {:created, %Ratings{}}
    * {:updated, %Ratings{}}
    * {:deleted, %Ratings{}}

  """
  def subscribe_ratings(%Scope{} = scope) do
    key = scope.account.id

    Phoenix.PubSub.subscribe(RideFast.PubSub, "user:#{key}:ratings")
  end

  defp broadcast_ratings(%Scope{} = scope, message) do
    key = scope.account.id

    Phoenix.PubSub.broadcast(RideFast.PubSub, "user:#{key}:ratings", message)
  end

  @doc """
  Returns the list of ratings.

  ## Examples

      iex> list_ratings(scope)
      [%Ratings{}, ...]

  """
  def list_ratings(to_driver_id) do
    Repo.all_by(Ratings, to_driver_id: to_driver_id)
  end

  @doc """
  Creates a ratings.

  ## Examples

      iex> create_ratings(scope, %{field: value})
      {:ok, %Ratings{}}

      iex> create_ratings(scope, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_ratings(%Scope{} = scope, attrs) do
    true = scope.role == :user

    ride = Repo.get_by!(Rides, id: attrs["rides_id"])

    true = ride.user_id == scope.account.id

    with {:ok, ratings = %Ratings{}} <-
           %Ratings{}
           |> Ratings.changeset(%{to_driver_id: ride.driver_id, ride_id: ride.id, score: attrs["score"], comment: attrs["comment"]}, scope)
           |> Repo.insert() do
      broadcast_ratings(scope, {:created, ratings})
      {:ok, ratings}
    end
  end
end
