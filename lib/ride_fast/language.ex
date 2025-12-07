defmodule RideFast.Language do
  use Ecto.Schema
  import Ecto.Changeset

  alias RideFast.Drivers.Driver

  schema "languages" do
    field :code, :string
    field :name, :string

    many_to_many :drivers, Driver,
      join_through: "drivers_languages",
      on_replace: :delete

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(language, attrs) do
    language
    |> cast(attrs, [:code, :name])
    |> validate_required([:code, :name])
    |> update_change(:code, &String.downcase/1)
    |> unique_constraint(:code)
  end
end
