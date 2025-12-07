defmodule RideFast.Repo.Migrations.CreateRideHistories do
  use Ecto.Migration

  def change do
    create table(:ride_histories) do
      add :from_state, :string
      add :to_state, :string
      add :rides_id, references(:rides, on_delete: :nothing)
      add :drivers_id, references(:drivers, on_delete: :nothing)
      add :users_id, references(:users, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:ride_histories, [:users_id])

    create index(:ride_histories, [:rides_id])
    create index(:ride_histories, [:drivers_id])
  end
end
