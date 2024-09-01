defmodule ElixirGist.GistsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ElixirGist.Gists` context.
  """

  @doc """
  Generate a gist.
  """
  def gist_fixture(attrs \\ %{}) do
    {:ok, gist} =
      attrs
      |> Enum.into(%{
        description: "some description",
        markup_text: "some markup_text",
        name: "some name"
      })
      |> ElixirGist.Gists.create_gist()

    gist
  end

  @doc """
  Generate a saved_gists.
  """
  def saved_gists_fixture(attrs \\ %{}) do
    {:ok, saved_gists} =
      attrs
      |> Enum.into(%{

      })
      |> ElixirGist.Gists.create_saved_gists()

    saved_gists
  end
end
