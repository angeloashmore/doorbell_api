defmodule DoorbellApi.TeamMemberControllerTest do
  use DoorbellApi.ConnCase

  alias DoorbellApi.TeamMember
  @valid_attrs %{email: "some content", private: true, roles_mask: 42, team_id: 42, title: "some content", user_id: 42}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, team_member_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    team_member = Repo.insert! %TeamMember{}
    conn = get conn, team_member_path(conn, :show, team_member)
    assert json_response(conn, 200)["data"] == %{id: team_member.id,
      user_id: team_member.user_id,
      team_id: team_member.team_id,
      title: team_member.title,
      email: team_member.email,
      private: team_member.private,
      roles_mask: team_member.roles_mask}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, team_member_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, team_member_path(conn, :create), team_member: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(TeamMember, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, team_member_path(conn, :create), team_member: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    team_member = Repo.insert! %TeamMember{}
    conn = put conn, team_member_path(conn, :update, team_member), team_member: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(TeamMember, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    team_member = Repo.insert! %TeamMember{}
    conn = put conn, team_member_path(conn, :update, team_member), team_member: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    team_member = Repo.insert! %TeamMember{}
    conn = delete conn, team_member_path(conn, :delete, team_member)
    assert response(conn, 204)
    refute Repo.get(TeamMember, team_member.id)
  end
end
