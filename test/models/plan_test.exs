defmodule DoorbellApi.PlanTest do
  use DoorbellApi.ModelCase

  alias DoorbellApi.Plan

  @valid_attrs %{name: "Default", type: "user"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Plan.changeset(%Plan{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Plan.changeset(%Plan{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "default_for_type! with valid types" do
    user = Plan.default_for_type!(:user)
    team = Plan.default_for_type!(:team)

    assert user.type == "user" && user.name == "Default"
    assert team.type == "team" && team.name == "Default"
  end
end
