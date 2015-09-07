defmodule DoorbellApi.TeamUserControllerTest do
  use DoorbellApi.ConnCase

  alias DoorbellApi.TeamUser
  alias DoorbellApi.User
  @valid_attrs %{
    email: "name@example.com",
    private: true,
    roles: ["owner"],
    team_id: 1,
    title: "Owner",
    user_id: 1}
  @invalid_attrs %{}

  setup do
    conn = conn()
    |> put_req_header("accept", "application/json")
    |> put_req_header("authorization", "Bearer " <> @valid_jwt)
    {:ok, conn: conn}
  end

  test "shows chosen resource", %{conn: conn} do
    team_user = Repo.get TeamUser, 1
    conn = get conn, team_user_path(conn, :show, team_user)
    assert json_response(conn, 200)["data"] == %{"id" => team_user.id,
      "user_id" => team_user.user_id,
      "team_id" => team_user.team_id,
      "title" => team_user.title,
      "email" => team_user.email,
      "private" => team_user.private,
      "roles" => team_user.roles}
  end

  test "does not show resource and instead responds with unauthorized when id is nonexistent", %{conn: conn} do
    conn = get conn, team_user_path(conn, :show, -1)
    assert json_response(conn, 401)["error"] == "Unauthorized"
  end

  test "does not show resource and instead responds with unauthorized when authorization header is nonexistent", %{conn: conn} do
    team_user = Repo.get TeamUser, 1
    conn = delete_req_header(conn, "authorization")
    conn = get conn, team_user_path(conn, :show, team_user)
    assert json_response(conn, 401)["error"] == "Unauthorized"
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    user = Repo.insert! %User{remote_id: "1", email: "another@example.com", name: "Name"}
    conn = post conn, team_user_path(conn, :create), team_user: %{@valid_attrs | user_id: user.id}
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(TeamUser, %{@valid_attrs | user_id: user.id})
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, team_user_path(conn, :create), team_user: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "does not create resource and instead responds with unauthorized when authorization header is nonexistent", %{conn: conn} do
    conn = delete_req_header(conn, "authorization")
    conn = post conn, team_user_path(conn, :create), team_user: @valid_attrs
    assert json_response(conn, 401)["error"] == "Unauthorized"
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    team_user = Repo.get TeamUser, 1
    conn = put conn, team_user_path(conn, :update, team_user), team_user: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(TeamUser, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    team_user = Repo.get TeamUser, 1
    conn = put conn, team_user_path(conn, :update, team_user), team_user: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "does not update chosen resource and instead responds with unauthorized when authorization header is nonexistent", %{conn: conn} do
    team_user = Repo.get TeamUser, 1
    conn = delete_req_header(conn, "authorization")
    conn = put conn, team_user_path(conn, :update, team_user), team_user: @valid_attrs
    assert json_response(conn, 401)["error"] == "Unauthorized"
  end

  test "deletes chosen resource", %{conn: conn} do
    team_user = Repo.get TeamUser, 1
    conn = delete conn, team_user_path(conn, :delete, team_user)
    assert response(conn, 204)
    refute Repo.get(TeamUser, team_user.id)
  end

  test "does not delete chosen resource and instead responds with unauthorized when authorization header is nonexistent", %{conn: conn} do
    team_user = Repo.get TeamUser, 1
    conn = delete_req_header(conn, "authorization")
    conn = delete conn, team_user_path(conn, :delete, team_user)
    assert json_response(conn, 401)["error"] == "Unauthorized"
  end
end
