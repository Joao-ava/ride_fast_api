defmodule RideFast.DriverLanguages.DriverLanguage do
  use Ecto.Schema
  import Ecto.Changeset

  schema "driver_languages" do
    field :driver_id, :id
    belongs_to :language, RideFast.Language

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(driver_language, attrs) do
    driver_language
    |> cast(attrs, [:driver_id, :language_id])
    |> validate_required([:driver_id, :language_id])
  end
end
