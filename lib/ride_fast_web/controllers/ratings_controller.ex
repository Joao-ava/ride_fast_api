defmodule RideFastWeb.RatingsController do
  use RideFastWeb, :controller

  alias RideFast.Rating
  alias RideFast.Rating.Ratings

  action_fallback RideFastWeb.FallbackController

  def index(conn, %{"driver_id" => driver_id}) do
    ratings = Rating.list_ratings(driver_id)
    render(conn, :index, ratings: ratings)
  end

  def create(conn, ratings_params) do
    with {:ok, %Ratings{} = ratings} <- Rating.create_ratings(conn.assigns.current_scope, ratings_params
                                                              |> Map.put(:rides_id, ratings_params["rides_id"])) do
      conn
      |> put_status(:created)
      |> render(:show, ratings: ratings)
    end
  end
end
