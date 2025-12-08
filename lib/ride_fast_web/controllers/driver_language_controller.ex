defmodule RideFastWeb.DriverLanguageController do
  use RideFastWeb, :controller

  alias RideFast.DriverLanguages
  alias RideFast.DriverLanguages.DriverLanguage

  action_fallback RideFastWeb.FallbackController

  def index(conn, %{"driver_id" => driver_id}) do
    driver_languages = DriverLanguages.list_driver_languages(driver_id)
    render(conn, :index, driver_languages: driver_languages)
  end

  def create(conn, driver_language_params) do
    with {:ok, %DriverLanguage{} = driver_language} <- DriverLanguages.create_driver_language(conn.assigns.current_scope, driver_language_params) do
      conn
      |> put_status(:created)
      |> render(:show, driver_language: driver_language)
    end
  end

  def delete(conn, %{"id" => language_id, "driver_id" => driver_id}) do
    driver_language = DriverLanguages.get_driver_language!(driver_id, language_id)

    with {:ok, %DriverLanguage{}} <- DriverLanguages.delete_driver_language(conn.assigns.current_scope, driver_language) do
      send_resp(conn, :no_content, "")
    end
  end
end
