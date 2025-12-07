defmodule RideFastWeb.LanguageController do
  use RideFastWeb, :controller

  alias RideFast.Languages
  alias RideFast.Language

  action_fallback RideFastWeb.FallbackController

  # GET /api/languages
  def index(conn, _params) do
    languages = Languages.list_languages()
    render(conn, :index, languages: languages)
  end

  # POST /api/languages
  def create(conn, language_params) do
    with {:ok, %Language{} = language} <- Languages.create_language(language_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/languages/#{language}")
      |> render(:show, language: language)
    end
  end

end
