defmodule DoorbellApi.TeamMemberControllerTest do
  use DoorbellApi.ConnCase

  alias DoorbellApi.TeamMember
  @valid_attrs %{
    email: "name@example.com",
    private: true,
    roles: ["owner"],
    team_id: 1,
    title: "Owner",
    user_id: 2}
  @invalid_attrs %{}

  setup do
    conn = conn()
    |> put_req_header("accept", "application/json")
    |> put_req_header("authorization", "Bearer " <> @valid_jwt)
    {:ok, conn: conn}
  end

  test "shows chosen resource", %{conn: conn} do
    team_member = Repo.insert! %TeamMember{team_id: 1, user_id: 1}
    conn = get conn, team_member_path(conn, :show, team_member)
    assert json_response(conn, 200)["data"] == %{"id" => team_member.id,
      "user_id" => team_member.user_id,
      "team_id" => team_member.team_id,
      "title" => team_member.title,
      "email" => team_member.email,
      "private" => team_member.private,
      "roles" => team_member.roles}
  end

  test "does not show resource and instead responds with unauthorized when id is nonexistent", %{conn: conn} do
    conn = get conn, team_member_path(conn, :show, -1)
    assert json_response(conn, 401)["error"] == "Unauthorized"
  end

  test "does not show resource and instead responds with unauthorized when authorization header is nonexistent", %{conn: conn} do
    team_member = Repo.insert! %TeamMember{team_id: 1}
    conn = delete_req_header(conn, "authorization")
    conn = get conn, team_member_path(conn, :show, team_member)
    assert json_response(conn, 401)["error"] == "Unauthorized"
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    Repo.insert!(%TeamMember{team_id: 1, user_id: 1, roles: ["owner"]})
    conn = post conn, team_member_path(conn, :create), team_member: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(TeamMember, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    Repo.insert!(%TeamMember{team_id: 1, user_id: 1, roles: ["owner"]})
    conn = post conn, team_member_path(conn, :create), team_member: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "does not create resource and instead responds with unauthorized when authorization header is nonexistent", %{conn: conn} do
    conn = delete_req_header(conn, "authorization")
    conn = post conn, team_member_path(conn, :create), team_member: @valid_attrs
    assert json_response(conn, 401)["error"] == "Unauthorized"
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    team_member = Repo.insert! %TeamMember{team_id: 1}
    Repo.insert!(%TeamMember{team_id: 1, user_id: 1, roles: ["owner"]})
    conn = put conn, team_member_path(conn, :update, team_member), team_member: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(TeamMember, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    team_member = Repo.insert! %TeamMember{team_id: 1}
    Repo.insert!(%TeamMember{team_id: 1, user_id: 1, roles: ["owner"]})
    conn = put conn, team_member_path(conn, :update, team_member), team_member: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "does not update chosen resource and instead responds with unauthorized when authorization header is nonexistent", %{conn: conn} do
    team_member = Repo.insert! %TeamMember{}
    conn = delete_req_header(conn, "authorization")
    conn = put conn, team_member_path(conn, :update, team_member), team_member: @valid_attrs
    assert json_response(conn, 401)["error"] == "Unauthorized"
  end

  test "deletes chosen resource", %{conn: conn} do
    team_member = Repo.insert! %TeamMember{team_id: 1}
    Repo.insert!(%TeamMember{team_id: 1, user_id: 1, roles: ["owner"]})
    conn = delete conn, team_member_path(conn, :delete, team_member)
    assert response(conn, 204)
    refute Repo.get(TeamMember, team_member.id)
  end

  test "does not delete chosen resource and instead responds with unauthorized when authorization header is nonexistent", %{conn: conn} do
    team_member = Repo.insert! %TeamMember{}
    conn = delete_req_header(conn, "authorization")
    conn = delete conn, team_member_path(conn, :delete, team_member)
    assert json_response(conn, 401)["error"] == "Unauthorized"
  end
end
