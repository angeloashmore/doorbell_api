defmodule DoorbellApi.TeamTest do
  use DoorbellApi.ModelCase

  alias DoorbellApi.Team

  @valid_attrs %{email: "some content", name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Team.changeset(%Team{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Team.changeset(%Team{}, @invalid_attrs)
    refute changeset.valid?
  end
end
