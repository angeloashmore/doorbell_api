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
  @invalid_attrs %{email: "invalidemail.com"}

  setup do
    conn = conn()
    |> put_req_header("accept", "application/json")
    |> put_req_header("authorization", "Bearer " <> @valid_jwt)
    {:ok, conn: conn}
  end

  test "shows chosen resource", %{conn: conn} do
    billing = Repo.get Billing, 1
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

  test "does not show resource and instead responds with unauthorized when id is nonexistent", %{conn: conn} do
    conn = get conn, billing_path(conn, :show, -1)
    assert json_response(conn, 401)["error"] == "Unauthorized"
  end

  test "does not show resource and instead responds with unauthorized when authorization header is nonexistent", %{conn: conn} do
    billing = Repo.get Billing, 1
    conn = delete_req_header(conn, "authorization")
    conn = get conn, billing_path(conn, :show, billing)
    assert json_response(conn, 401)["error"] == "Unauthorized"
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    billing = Repo.get Billing, 1
    conn = put conn, billing_path(conn, :update, billing), billing: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Billing, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    billing = Repo.get Billing, 1
    conn = put conn, billing_path(conn, :update, billing), billing: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "does not update chosen resource and instead responds with unauthorized when authorization header is nonexistent", %{conn: conn} do
    billing = Repo.get Billing, 1
    conn = delete_req_header(conn, "authorization")
    conn = put conn, billing_path(conn, :update, billing), billing: @valid_attrs
    assert json_response(conn, 401)["error"] == "Unauthorized"
  end
end
