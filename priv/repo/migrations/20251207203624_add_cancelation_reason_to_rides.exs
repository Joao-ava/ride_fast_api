defmodule RideFast.Repo.Migrations.AddCancelationReasonToRides do
  use Ecto.Migration

  def change do
    alter table(:rides) do
      add :cancelation_reason, :string
    end
  end
end
