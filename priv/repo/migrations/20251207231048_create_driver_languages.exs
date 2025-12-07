defmodule RideFast.Repo.Migrations.CreateDriverLanguages do
  use Ecto.Migration

  def change do
    create table(:driver_languages) do
      add :driver_id, references(:drivers, on_delete: :nothing)
      add :language_id, references(:languages, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:driver_languages, [:driver_id])
    create index(:driver_languages, [:language_id])
  end
end
