defmodule DoorbellApi.UserTest do
  use DoorbellApi.ModelCase

  alias DoorbellApi.User

  @valid_attrs %{
    remote_id: "auth0|1234",
    email: "name@example.com",
    name: "John Doe"}
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
