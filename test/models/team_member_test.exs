defmodule DoorbellApi.TeamMemberTest do
  use DoorbellApi.ModelCase

  alias DoorbellApi.TeamMember

  @valid_attrs %{email: "some content", private: true, roles_mask: 42, team_id: 42, title: "some content", user_id: 42}
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
