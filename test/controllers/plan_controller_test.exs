defmodule DoorbellApi.PlanControllerTest do
  use DoorbellApi.ConnCase

  alias DoorbellApi.Plan
  @valid_attrs %{name: "Deluxe", type: "user"}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, plan_path(conn, :index)
    assert length(json_response(conn, 200)["data"]) == 2
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

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, plan_path(conn, :create), plan: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Plan, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, plan_path(conn, :create), plan: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    plan = Repo.insert! %Plan{}
    conn = put conn, plan_path(conn, :update, plan), plan: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Plan, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    plan = Repo.insert! %Plan{}
    conn = put conn, plan_path(conn, :update, plan), plan: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    plan = Repo.insert! %Plan{}
    conn = delete conn, plan_path(conn, :delete, plan)
    assert response(conn, 204)
    refute Repo.get(Plan, plan.id)
  end
end
