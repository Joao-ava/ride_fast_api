defmodule RideFast.DriverLanguages do
  @moduledoc """
  The DriverLanguages context.
  """

  import Ecto.Query, warn: false
  alias RideFast.Repo

  alias RideFast.DriverLanguages.DriverLanguage
  alias RideFast.Accounts.Scope

  @doc """
  Subscribes to scoped notifications about any driver_language changes.

  The broadcasted messages match the pattern:

    * {:created, %DriverLanguage{}}
    * {:updated, %DriverLanguage{}}
    * {:deleted, %DriverLanguage{}}

  """
  def subscribe_driver_languages(%Scope{} = scope) do
    key = scope.account.id

    Phoenix.PubSub.subscribe(RideFast.PubSub, "user:#{key}:driver_languages")
  end

  defp broadcast_driver_language(%Scope{} = scope, message) do
    key = scope.account.id

    Phoenix.PubSub.broadcast(RideFast.PubSub, "user:#{key}:driver_languages", message)
  end

  @doc """
  Returns the list of driver_languages.

  ## Examples

      iex> list_driver_languages(scope)
      [%DriverLanguage{}, ...]

  """
  def list_driver_languages(driver_id) do
    Repo.all_by(DriverLanguage, driver_id: driver_id)
    |> Repo.preload(:language)
  end

  @doc """
  Gets a single driver_language.

  Raises `Ecto.NoResultsError` if the Driver language does not exist.

  ## Examples

      iex> get_driver_language!(scope, 123)
      %DriverLanguage{}

      iex> get_driver_language!(scope, 456)
      ** (Ecto.NoResultsError)

  """
  def get_driver_language!(driver_id, language_id) do
    Repo.get_by!(DriverLanguage, driver_id: driver_id, language_id: language_id)
  end

  @doc """
  Creates a driver_language.

  ## Examples

      iex> create_driver_language(scope, %{field: value})
      {:ok, %DriverLanguage{}}

      iex> create_driver_language(scope, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_driver_language(%Scope{} = scope, attrs) do
    with {:ok, driver_language = %DriverLanguage{}} <-
           %DriverLanguage{}
           |> DriverLanguage.changeset(attrs)
           |> Repo.insert() do
      broadcast_driver_language(scope, {:created, driver_language})
      {:ok, driver_language}
    end
  end

  @doc """
  Deletes a driver_language.

  ## Examples

      iex> delete_driver_language(scope, driver_language)
      {:ok, %DriverLanguage{}}

      iex> delete_driver_language(scope, driver_language)
      {:error, %Ecto.Changeset{}}

  """
  def delete_driver_language(%Scope{} = scope, %DriverLanguage{} = driver_language) do
    true = driver_language.driver_id == scope.account.id || scope.role == :admin

    with {:ok, driver_language = %DriverLanguage{}} <-
           Repo.delete(driver_language) do
      broadcast_driver_language(scope, {:deleted, driver_language})
      {:ok, driver_language}
    end
  end
end
