defmodule DoorbellApi.GenUserTest do
  use DoorbellApi.ModelCase

  alias DoorbellApi.GenUser

  @valid_attrs %{user_id: 1}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = GenUser.changeset(%GenUser{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = GenUser.changeset(%GenUser{}, @invalid_attrs)
    refute changeset.valid?
  end
end
