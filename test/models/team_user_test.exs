defmodule DoorbellApi.TeamUserTest do
  use DoorbellApi.ModelCase

  alias DoorbellApi.TeamUser

  @valid_attrs %{
    email: "name@example.com",
    private: true,
    roles: ["owner"],
    team_id: 1,
    title: "Owner",
    user_id: 1}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = TeamUser.changeset(%TeamUser{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = TeamUser.changeset(%TeamUser{}, @invalid_attrs)
    refute changeset.valid?
  end
end
