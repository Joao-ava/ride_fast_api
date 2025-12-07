defmodule RideFast.Drivers.Vehicles do
  use Ecto.Schema
  import Ecto.Changeset

  schema "vehicles" do
    field :plate, :string
    field :model, :string
    field :color, :string
    field :seats, :integer
    field :active, :boolean, default: false
    field :driver_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(vehicles, attrs, account_scope) do
    driver_id = case account_scope.role do
      :driver -> account_scope.account.id
      _ ->
        {value, _} = Integer.parse(attrs["driver_id"])
        value
    end
    vehicles
    |> cast(attrs, [:plate, :model, :color, :seats])
    |> validate_required([:plate, :model, :color, :seats])
    |> put_change(:driver_id, driver_id)
    |> put_change(:active, true)
    |> validate_required([:driver_id])
  end

  def delete_changeset(vehicles) do
    vehicles
    |> Ecto.Changeset.change(%{active: false})
  end
end
