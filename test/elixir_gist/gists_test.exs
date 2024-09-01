defmodule ElixirGist.GistsTest do
  use ElixirGist.DataCase

  alias ElixirGist.Gists

  describe "gists" do
    alias ElixirGist.Gists.Gist

    import ElixirGist.GistsFixtures

    @invalid_attrs %{name: nil, description: nil, markup_text: nil}

    test "list_gists/0 returns all gists" do
      gist = gist_fixture()
      assert Gists.list_gists() == [gist]
    end

    test "get_gist!/1 returns the gist with given id" do
      gist = gist_fixture()
      assert Gists.get_gist!(gist.id) == gist
    end

    test "create_gist/1 with valid data creates a gist" do
      valid_attrs = %{name: "some name", description: "some description", markup_text: "some markup_text"}

      assert {:ok, %Gist{} = gist} = Gists.create_gist(valid_attrs)
      assert gist.name == "some name"
      assert gist.description == "some description"
      assert gist.markup_text == "some markup_text"
    end

    test "create_gist/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Gists.create_gist(@invalid_attrs)
    end

    test "update_gist/2 with valid data updates the gist" do
      gist = gist_fixture()
      update_attrs = %{name: "some updated name", description: "some updated description", markup_text: "some updated markup_text"}

      assert {:ok, %Gist{} = gist} = Gists.update_gist(gist, update_attrs)
      assert gist.name == "some updated name"
      assert gist.description == "some updated description"
      assert gist.markup_text == "some updated markup_text"
    end

    test "update_gist/2 with invalid data returns error changeset" do
      gist = gist_fixture()
      assert {:error, %Ecto.Changeset{}} = Gists.update_gist(gist, @invalid_attrs)
      assert gist == Gists.get_gist!(gist.id)
    end

    test "delete_gist/1 deletes the gist" do
      gist = gist_fixture()
      assert {:ok, %Gist{}} = Gists.delete_gist(gist)
      assert_raise Ecto.NoResultsError, fn -> Gists.get_gist!(gist.id) end
    end

    test "change_gist/1 returns a gist changeset" do
      gist = gist_fixture()
      assert %Ecto.Changeset{} = Gists.change_gist(gist)
    end
  end

  describe "saved_gists" do
    alias ElixirGist.Gists.SavedGists

    import ElixirGist.GistsFixtures

    @invalid_attrs %{}

    test "list_saved_gists/0 returns all saved_gists" do
      saved_gists = saved_gists_fixture()
      assert Gists.list_saved_gists() == [saved_gists]
    end

    test "get_saved_gists!/1 returns the saved_gists with given id" do
      saved_gists = saved_gists_fixture()
      assert Gists.get_saved_gists!(saved_gists.id) == saved_gists
    end

    test "create_saved_gists/1 with valid data creates a saved_gists" do
      valid_attrs = %{}

      assert {:ok, %SavedGists{} = saved_gists} = Gists.create_saved_gists(valid_attrs)
    end

    test "create_saved_gists/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Gists.create_saved_gists(@invalid_attrs)
    end

    test "update_saved_gists/2 with valid data updates the saved_gists" do
      saved_gists = saved_gists_fixture()
      update_attrs = %{}

      assert {:ok, %SavedGists{} = saved_gists} = Gists.update_saved_gists(saved_gists, update_attrs)
    end

    test "update_saved_gists/2 with invalid data returns error changeset" do
      saved_gists = saved_gists_fixture()
      assert {:error, %Ecto.Changeset{}} = Gists.update_saved_gists(saved_gists, @invalid_attrs)
      assert saved_gists == Gists.get_saved_gists!(saved_gists.id)
    end

    test "delete_saved_gists/1 deletes the saved_gists" do
      saved_gists = saved_gists_fixture()
      assert {:ok, %SavedGists{}} = Gists.delete_saved_gists(saved_gists)
      assert_raise Ecto.NoResultsError, fn -> Gists.get_saved_gists!(saved_gists.id) end
    end

    test "change_saved_gists/1 returns a saved_gists changeset" do
      saved_gists = saved_gists_fixture()
      assert %Ecto.Changeset{} = Gists.change_saved_gists(saved_gists)
    end
  end
end
