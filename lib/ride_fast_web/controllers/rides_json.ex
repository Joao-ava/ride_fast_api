defmodule RideFastWeb.RidesJSON do
  alias RideFast.Ride.{Rides, RideHistory}
  alias RideFastWeb.AccountJSON

  @doc """
  Renders a list of rides.
  """
  def index(%{rides: rides}) do
    %{data: for(rides <- rides, do: data(rides))}
  end

  def index(%{histories: histories}) do
    %{data: for(history <- histories, do: data_history(history))}
  end

  @doc """
  Renders a single rides.
  """
  def show(%{rides: rides}) do
    data(rides)
  end

  def data_history(%RideHistory{} = history) do
    %{
      from_state: history.from_state,
      to_state: history.to_state,
      actor_type: cond do
        history.drivers_id -> "driver"
        true -> "user"
      end,
      actor_id: cond do
        history.drivers_id -> history.drivers_id
        true -> history.users_id
      end,
      timestamp: history.inserted_at
    }
  end

  defp data(%Rides{} = rides) do
    %{
      id: rides.id,
      origin: %{
        lat: rides.origin_lat,
        lng: rides.origin_lng,
      },
      destination: %{
        lat: rides.dest_lat,
        lng: rides.dest_lng,
      },
      histories: case rides.histories do
        %Ecto.Association.NotLoaded{} -> []
        list -> Enum.map(list, &data_history/1)
      end,
      driver: case rides.driver do
        %Ecto.Association.NotLoaded{} -> nil
        driver -> AccountJSON.show(%{account: driver})
      end,
      user: AccountJSON.show(%{account: rides.user}),
      price_estimate: rides.price_estimate,
      final_price: rides.final_price,
      status: rides.status,
      requested_at: rides.requested_at,
      started_at: rides.started_at,
      ended_at: rides.ended_at
    }
  end
end
