defmodule RideFast.Ride.RideHistory do
  use Ecto.Schema
  import Ecto.Changeset

  schema "ride_histories" do
    field :from_state, :string
    field :to_state, :string
    field :rides_id, :id
    field :drivers_id, :id
    field :users_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(ride_history, attrs) do
    ride_history
    |> cast(attrs, [:from_state, :to_state, :rides_id, :drivers_id, :users_id])
    |> validate_required([:from_state, :to_state, :rides_id])
  end
end
