defmodule ElixirGist.Gists do
  @moduledoc """
  The Gists context.
  """

  import Ecto.Query, warn: false
  alias ElixirGist.Repo

  alias ElixirGist.Gists.Gist

  alias ElixirGist.Accounts.User

  @doc """
  Returns the list of gists.

  ## Examples

      iex> list_gists()
      [%Gist{}, ...]

  """
  def list_gists do
    Repo.all(Gist)
  end

  @doc """
  Gets a single gist.

  Raises `Ecto.NoResultsError` if the Gist does not exist.

  ## Examples

      iex> get_gist!(123)
      %Gist{}

      iex> get_gist!(456)
      ** (Ecto.NoResultsError)

  """
  def get_gist!(id), do: Repo.get!(Gist, id)

  @doc """
  Creates a gist.

  ## Examples

      iex> create_gist(%{field: value})
      {:ok, %Gist{}}

      iex> create_gist(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_gist(user, attrs \\ %{}) do
    user
    |> Ecto.build_assoc(:gists)
    |> Gist.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a gist.

  ## Examples

      iex> update_gist(gist, %{field: new_value})
      {:ok, %Gist{}}

      iex> update_gist(gist, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_gist(%User{} = user, attrs) do
    gist = Repo.get!(Gist, attrs["id"])

    if user.id == gist.user_id do
      gist
      |> Gist.changeset(attrs)
      |> Repo.update()
    else
      {:error, :unauthorized}
    end
  end

  @doc """
  Deletes a gist.

  ## Examples

      iex> delete_gist(gist)
      {:ok, %Gist{}}

      iex> delete_gist(gist)
      {:error, %Ecto.Changeset{}}

  """
  def delete_gist(%User{} = user, gist_id) do
    gist = Repo.get!(Gist, gist_id)

    if user.id == gist.user_id do
      Repo.delete(gist)
      {:ok, gist}
    else
      {:error, :unauthorized}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking gist changes.

  ## Examples

      iex> change_gist(gist)
      %Ecto.Changeset{data: %Gist{}}

  """
  def change_gist(%Gist{} = gist, attrs \\ %{}) do
    Gist.changeset(gist, attrs)
  end

  alias ElixirGist.Gists.SavedGists

  @doc """
  Returns the list of saved_gists.

  ## Examples

      iex> list_saved_gists()
      [%SavedGists{}, ...]

  """
  def list_saved_gists do
    Repo.all(SavedGists)
  end

  @doc """
  Gets a single saved_gists.

  Raises `Ecto.NoResultsError` if the Saved gists does not exist.

  ## Examples

      iex> get_saved_gists!(123)
      %SavedGists{}

      iex> get_saved_gists!(456)
      ** (Ecto.NoResultsError)

  """
  def get_saved_gists!(id), do: Repo.get!(SavedGists, id)

  @doc """
  Creates a saved_gists.

  ## Examples

      iex> create_saved_gists(%{field: value})
      {:ok, %SavedGists{}}

      iex> create_saved_gists(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_saved_gists(users, attrs \\ %{}) do
    users
    |> Ecto.build_assoc(:saved_gists)
    |> SavedGists.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a saved_gists.

  ## Examples

      iex> update_saved_gists(saved_gists, %{field: new_value})
      {:ok, %SavedGists{}}

      iex> update_saved_gists(saved_gists, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_saved_gists(%SavedGists{} = saved_gists, attrs) do
    saved_gists
    |> SavedGists.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a saved_gists.

  ## Examples

      iex> delete_saved_gists(saved_gists)
      {:ok, %SavedGists{}}

      iex> delete_saved_gists(saved_gists)
      {:error, %Ecto.Changeset{}}

  """
  def delete_saved_gists(%SavedGists{} = saved_gists) do
    Repo.delete(saved_gists)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking saved_gists changes.

  ## Examples

      iex> change_saved_gists(saved_gists)
      %Ecto.Changeset{data: %SavedGists{}}

  """
  def change_saved_gists(%SavedGists{} = saved_gists, attrs \\ %{}) do
    SavedGists.changeset(saved_gists, attrs)
  end
end
