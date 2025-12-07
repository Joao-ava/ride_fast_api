defmodule RideFast.Repo.Migrations.CreateRides do
  use Ecto.Migration

  def change do
    create table(:rides) do
      add :origin_lat, :decimal
      add :origin_lng, :decimal
      add :dest_lat, :decimal
      add :dest_lng, :decimal
      add :price_estimate, :decimal
      add :final_price, :decimal
      add :status, :string
      add :payment_method, :string
      add :requested_at, :utc_datetime
      add :started_at, :utc_datetime
      add :ended_at, :utc_datetime
      add :user_id, references(:users, on_delete: :nothing)
      add :driver_id, references(:drivers, on_delete: :nothing)
      add :vehicle_id, references(:vehicles, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:rides, [:user_id])
    create index(:rides, [:driver_id])
    create index(:rides, [:vehicle_id])
  end
end
