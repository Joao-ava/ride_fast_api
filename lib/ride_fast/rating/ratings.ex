defmodule RideFast.Rating.Ratings do
  use Ecto.Schema
  import Ecto.Changeset

  schema "ratings" do
    field :score, :integer
    field :comment, :string
    field :ride_id, :id
    field :from_user_id, :id
    field :to_driver_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(ratings, attrs, account_scope) do
    ratings
    |> cast(attrs, [:score, :comment, :ride_id, :to_driver_id])
    |> validate_required([:score, :comment, :ride_id, :to_driver_id])
    |> put_change(:from_user_id, account_scope.account.id)
  end
end
