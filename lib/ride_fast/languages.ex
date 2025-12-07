defmodule RideFast.Languages do
  @moduledoc """
  The Languages context.
  """

  alias RideFast.Repo
  alias RideFast.Language

  def list_languages do
    Repo.all(Language)
  end

  def get_language!(id), do: Repo.get!(Language, id)

  def create_language(attrs) do
    %Language{}
    |> Language.changeset(attrs)
    |> Repo.insert()
  end

  def update_language(%Language{} = lang, attrs) do
    lang
    |> Language.changeset(attrs)
    |> Repo.update()
  end

  def delete_language(%Language{} = lang) do
    Repo.delete(lang)
  end
end
