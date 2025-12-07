defmodule RideFastWeb.LanguageJSON do
  alias RideFast.Language

  @doc """
  Renders a list of languages.
  """
  def index(%{languages: languages}) do
    %{data: for(language <- languages, do: data(language))}
  end

  @doc """
  Renders a single language.
  """
  def show(%{language: language}) do
    data(language)
  end

  defp data(%Language{} = language) do
    %{
      id: language.id,
      code: language.code,
      name: language.name,
      inserted_at: language.inserted_at,
      updated_at: language.updated_at
    }
  end
end
