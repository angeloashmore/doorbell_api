defmodule DoorbellApi.UserTest do
  use DoorbellApi.ModelCase

  alias DoorbellApi.User

  @valid_attrs %{email: "some content", name: "some content", remote_id: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
