defmodule RideFastWeb.DriverLanguageJSON do
  alias RideFast.DriverLanguages.DriverLanguage
  alias RideFastWeb.LanguageJSON

  @doc """
  Renders a list of driver_languages.
  """
  def index(%{driver_languages: driver_languages}) do
    %{data: for(driver_language <- driver_languages, do: LanguageJSON.show(%{language: driver_language.language}))}
  end

  @doc """
  Renders a single driver_language.
  """
  def show(%{driver_language: driver_language}) do
    data(driver_language)
  end

  defp data(%DriverLanguage{} = driver_language) do
    %{
      driver_id: driver_language.driver_id,
      language_id: driver_language.language_id,
    }
  end
end
