defmodule RideFast.Ride.Rides do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  schema "rides" do
    field :origin_lat, :decimal
    field :origin_lng, :decimal
    field :dest_lat, :decimal
    field :dest_lng, :decimal
    field :price_estimate, :decimal
    field :final_price, :decimal
    field :status, :string
    field :payment_method, :string
    field :requested_at, :utc_datetime
    field :started_at, :utc_datetime
    field :ended_at, :utc_datetime
    field :cancelation_reason, :string
    belongs_to :user, RideFast.Accounts.User
    belongs_to :driver, RideFast.Drivers.Driver
    belongs_to :vehicle, RideFast.Drivers.Vehicles
    has_many :histories, RideFast.Ride.RideHistory

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(rides, attrs, user_scope) do
    rides
    |> cast(attrs, [:origin_lat, :origin_lng, :dest_lat, :dest_lng, :price_estimate, :payment_method])
    |> validate_required([:origin_lat, :origin_lng, :dest_lat, :dest_lng, :price_estimate, :payment_method])
    |> put_change(:user_id, user_scope.account.id)
    |> put_change(:status, "SOLICITADA")
    |> put_change(:requested_at, DateTime.truncate(DateTime.utc_now(), :second))
  end

  def accept(ride, attrs) do
    ride
    |> cast(attrs, [:vehicle_id, :driver_id])
    |> validate_required([:vehicle_id, :driver_id])
    |> put_change(:status, "ACEITA")
    # |> Ecto.Changeset.change(%{status: "ACEITA"})
  end

  def start(ride) do
    ride
    |> change(%{status: "EM_ANDAMENTO"})
    |> put_change(:started_at, DateTime.truncate(DateTime.utc_now(), :second))
  end

  def complete(ride, attrs) do
    ride
    |> cast(attrs, [:final_price])
    |> validate_required([:final_price])
    |> put_change(:status, "FINALIZADA")
    |> put_change(:final_price, ride.price_estimate)
    |> put_change(:ended_at, DateTime.truncate(DateTime.utc_now(), :second))
  end

  def cancel(ride, attrs) do
    ride
    |> cast(attrs, [:cancelation_reason])
    |> validate_required([:cancelation_reason])
    |> put_change(:status, "CANCELADA")
  end

  def list_filter(filters \\ %{}) do
    base_query = from r in RideFast.Ride.Rides
    query =
      base_query
      |> filter_status(filters)
      |> filter_user(filters)
      |> filter_driver(filters)

    # paginação simples
    page = Map.get(filters, "page", "1") |> String.to_integer()
    size = Map.get(filters, "size", "10") |> String.to_integer()

    query
    |> limit(^size)
    |> offset(^((page - 1) * size))
  end

  defp filter_status(query, %{"status" => status}) when status != "" do
    from r in query, where: r.status == ^status
  end
  defp filter_status(query, _), do: query

  defp filter_user(query, %{"user_id" => user_id}) when user_id != "" do
    from r in query, where: r.user_id == ^String.to_integer(user_id)
  end
  defp filter_user(query, _), do: query

  defp filter_driver(query, %{"driver_id" => driver_id}) when driver_id != "" do
    from r in query, where: r.driver_id == ^String.to_integer(driver_id)
  end
  defp filter_driver(query, _), do: query
end
