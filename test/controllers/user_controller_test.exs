defmodule DoorbellApi.UserControllerTest do
  use DoorbellApi.ConnCase

  alias DoorbellApi.User
  @valid_attrs %{
    remote_id: "auth0|1234",
    email: "another@example.com",
    name: "John Doe"}
  @invalid_attrs %{email: "invalidemail.com"}

  setup do
    conn = conn()
    |> put_req_header("accept", "application/json")
    |> put_req_header("authorization", "Bearer " <> @valid_jwt)
    {:ok, conn: conn}
  end

  test "shows chosen resource", %{conn: conn} do
    user = Repo.get(User, 1)
    conn = get conn, user_path(conn, :show, user)
    assert json_response(conn, 200)["data"] == %{"id" => user.id,
      "remote_id" => user.remote_id,
      "email" => user.email,
      "name" => user.name}
  end

  test "does not show resource and instead responds with unauthorized when id is nonexistent", %{conn: conn} do
    conn = get conn, user_path(conn, :show, -1)
    assert json_response(conn, 401)["error"] == "Unauthorized"
  end

  test "does not show resource and instead responds with unauthorized when authorization header is nonexistent", %{conn: conn} do
    user = Repo.insert! %User{}
    conn = delete_req_header(conn, "authorization")
    conn = get conn, user_path(conn, :show, user)
    assert json_response(conn, 401)["error"] == "Unauthorized"
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = put_req_header(conn, "authorization", "Bearer " <> @valid_auth0_jwt)
    conn = post conn, user_path(conn, :create), user: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(User, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = put_req_header(conn, "authorization", "Bearer " <> @valid_auth0_jwt)
    conn = post conn, user_path(conn, :create), user: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "does not create resource and instead responds with unauthorized when authorization header is nonexistent", %{conn: conn} do
    conn = delete_req_header(conn, "authorization")
    conn = post conn, user_path(conn, :create), user: @valid_attrs
    assert json_response(conn, 401)["error"] == "Unauthorized"
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    user = Repo.get(User, 1)
    conn = put conn, user_path(conn, :update, user), user: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(User, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    user = Repo.get(User, 1)
    conn = put conn, user_path(conn, :update, user), user: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "does not update chosen resource and instead responds with unauthorized when authorization header is nonexistent", %{conn: conn} do
    user = Repo.insert! %User{}
    conn = delete_req_header(conn, "authorization")
    conn = put conn, user_path(conn, :update, user), user: @valid_attrs
    assert json_response(conn, 401)["error"] == "Unauthorized"
  end
end
