defmodule DoorbellApi.BillingControllerTest do
  use DoorbellApi.ConnCase

  alias DoorbellApi.Billing
  @valid_attrs %{
    plan_id: 1,
    user_id: 1,
    email: "name@example.com",
    stripe_customer_id: "cus_mockID",
    brand: "visa",
    last4: "4242",
    exp_month: "03",
    exp_year: "2016"}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, billing_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    billing = Repo.insert! %Billing{}
    conn = get conn, billing_path(conn, :show, billing)
    assert json_response(conn, 200)["data"] == %{"id" => billing.id,
      "plan_id" => billing.plan_id,
      "user_id" => billing.user_id,
      "team_id" => billing.team_id,
      "stripe_customer_id" => billing.stripe_customer_id,
      "email" => billing.email,
      "brand" => billing.brand,
      "last4" => billing.last4,
      "exp_month" => billing.exp_month,
      "exp_year" => billing.exp_year}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, billing_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, billing_path(conn, :create), billing: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Billing, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, billing_path(conn, :create), billing: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    billing = Repo.insert! %Billing{}
    conn = put conn, billing_path(conn, :update, billing), billing: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Billing, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    billing = Repo.insert! %Billing{}
    conn = put conn, billing_path(conn, :update, billing), billing: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    billing = Repo.insert! %Billing{}
    conn = delete conn, billing_path(conn, :delete, billing)
    assert response(conn, 204)
    refute Repo.get(Billing, billing.id)
  end
end
