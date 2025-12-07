defmodule RideFastWeb.RatingsJSON do
  alias RideFast.Rating.Ratings

  @doc """
  Renders a list of ratings.
  """
  def index(%{ratings: ratings}) do
    %{data: for(ratings <- ratings, do: data(ratings))}
  end

  @doc """
  Renders a single ratings.
  """
  def show(%{ratings: ratings}) do
    %{data: data(ratings)}
  end

  defp data(%Ratings{} = ratings) do
    %{
      id: ratings.id,
      score: ratings.score,
      comment: ratings.comment
    }
  end
end
