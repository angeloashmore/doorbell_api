defmodule DoorbellApi.TeamControllerTest do
  use DoorbellApi.ConnCase

  alias DoorbellApi.Team
  alias DoorbellApi.TeamUser
  @valid_attrs %{email: "name@example.com", name: "Doorbell"}
  @invalid_attrs %{}

  setup do
    conn = conn()
    |> put_req_header("accept", "application/json")
    |> put_req_header("authorization", "Bearer " <> @valid_jwt)
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, team_path(conn, :index)
    assert length(json_response(conn, 200)["data"]) == 1
  end

  test "does not list all entries and instead responds with unauthorized when authorization header is nonexistent", %{conn: conn} do
    conn = delete_req_header(conn, "authorization")
    conn = get conn, team_path(conn, :index)
    assert json_response(conn, 401)["error"] == "Unauthorized"
  end

  test "shows chosen resource", %{conn: conn} do
    team = Repo.insert! %Team{}
    team_user = Repo.insert!(%TeamUser{team_id: team.id, user_id: 1})
    conn = get conn, team_path(conn, :show, team)
    assert json_response(conn, 200)["data"] == %{"id" => team.id,
      "name" => team.name,
      "email" => team.email,
      "team_users" => [%{
        "id" => team_user.id,
        "team_id" => team_user.team_id,
        "user_id" => team_user.user_id,
        "email" => team_user.email,
        "title" => team_user.title,
        "private" => team_user.private,
        "roles" => team_user.roles
      }]}
  end

  test "does not show resource and instead responds with unauthorized when id is nonexistent", %{conn: conn} do
    conn = get conn, team_path(conn, :show, -1)
    assert json_response(conn, 401)["error"] == "Unauthorized"
  end

  test "does not show resource and instead responds with unauthorized when authorization header is nonexistent", %{conn: conn} do
    team = Repo.insert! %Team{}
    conn = delete_req_header(conn, "authorization")
    conn = get conn, team_path(conn, :show, team)
    assert json_response(conn, 401)["error"] == "Unauthorized"
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, team_path(conn, :create), team: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Team, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, team_path(conn, :create), team: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "does not create resource and instead responds with unauthorized when authorization header is nonexistent", %{conn: conn} do
    conn = delete_req_header(conn, "authorization")
    conn = post conn, team_path(conn, :create), team: @valid_attrs
    assert json_response(conn, 401)["error"] == "Unauthorized"
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    team = Repo.insert! %Team{}
    Repo.insert!(%TeamUser{team_id: team.id, user_id: 1, roles: ["owner"]})
    conn = put conn, team_path(conn, :update, team), team: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Team, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    team = Repo.insert! %Team{}
    Repo.insert!(%TeamUser{team_id: team.id, user_id: 1, roles: ["owner"]})
    conn = put conn, team_path(conn, :update, team), team: @invalid_attrs
    assert json_response(conn, 422)["error"] != %{}
  end

  test "does not update chosen resource and instead responds with unauthorized when authorization header is nonexistent", %{conn: conn} do
    team = Repo.insert! %Team{}
    conn = delete_req_header(conn, "authorization")
    conn = put conn, team_path(conn, :update, team), team: @invalid_attrs
    assert json_response(conn, 401)["error"] == "Unauthorized"
  end

  test "deletes chosen resource", %{conn: conn} do
    team = Repo.insert! %Team{}
    Repo.insert!(%TeamUser{team_id: team.id, user_id: 1, roles: ["owner"]})
    conn = delete conn, team_path(conn, :delete, team)
    assert response(conn, 204)
    refute Repo.get(Team, team.id)
  end

  test "does not delete chosen resource and instead responds with unauthorized when authorization header is nonexistent", %{conn: conn} do
    team = Repo.insert! %Team{}
    conn = delete_req_header(conn, "authorization")
    conn = delete conn, team_path(conn, :delete, team)
    assert json_response(conn, 401)["error"] == "Unauthorized"
  end
end
