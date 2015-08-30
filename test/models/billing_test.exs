defmodule DoorbellApi.BillingTest do
  use DoorbellApi.ModelCase

  alias DoorbellApi.Billing

  @valid_attrs %{
    plan_id: 1,
    user_id: 1,
    team_id: nil,
    email: "name@example.com",
    stripe_customer_id: "cus_mockID",
    brand: "visa",
    last4: "4242",
    exp_month: "03",
    exp_year: "2016"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Billing.changeset(%Billing{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Billing.changeset(%Billing{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "type" do
    billing = %Billing{}
    assert Billing.type(%{billing | user_id: 1}) == :user
    assert Billing.type(%{billing | team_id: 1}) == :team
    assert Billing.type(billing) == :unknown
  end
end
