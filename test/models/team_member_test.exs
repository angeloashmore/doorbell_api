defmodule DoorbellApi.TeamMemberTest do
  use DoorbellApi.ModelCase

  alias DoorbellApi.TeamMember

  @valid_attrs %{
    email: "name@example.com",
    private: true,
    roles: ["owner"],
    team_id: 1,
    title: "Owner",
    user_id: 1}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = TeamMember.changeset(%TeamMember{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = TeamMember.changeset(%TeamMember{}, @invalid_attrs)
    refute changeset.valid?
  end
end
