defmodule DoorbellApi.PlanControllerTest do
  use DoorbellApi.ConnCase

  alias DoorbellApi.Plan
  @valid_attrs %{name: "Deluxe", type: "user"}
  @invalid_attrs %{}

  setup do
    conn = conn()
    |> put_req_header("accept", "application/json")
    |> put_req_header("authorization", "Bearer " <> @valid_jwt)
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, plan_path(conn, :index)
    assert length(json_response(conn, 200)["data"]) == 2
  end

  test "does not list all entries and instead reponds with unauthorized when authorization header is nonexistent", %{conn: conn} do
    conn = delete_req_header(conn, "authorization")
    conn = get conn, plan_path(conn, :index)
    assert json_response(conn, 401)["error"] == "Unauthorized"
  end

  test "shows chosen resource", %{conn: conn} do
    plan = Repo.insert! %Plan{}
    conn = get conn, plan_path(conn, :show, plan)
    assert json_response(conn, 200)["data"] == %{"id" => plan.id,
      "name" => plan.name,
      "type" => plan.type}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, plan_path(conn, :show, -1)
    end
  end

  test "does not show resource and instead reponds with unauthorized when authorization header is nonexistent", %{conn: conn} do
    plan = Repo.insert! %Plan{}
    conn = delete_req_header(conn, "authorization")
    conn = get conn, plan_path(conn, :show, plan)
    assert json_response(conn, 401)["error"] == "Unauthorized"
  end
end
