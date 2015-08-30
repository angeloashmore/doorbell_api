defmodule DoorbellApi.BillingTest do
  use DoorbellApi.ModelCase

  alias DoorbellApi.Billing

  @valid_attrs %{brand: "some content", email: "some content", exp_month: "some content", exp_year: "some content", last4: "some content", plan_id: 42, relation_id: 42, relation_type: "some content", stripe_customer_id: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Billing.changeset(%Billing{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Billing.changeset(%Billing{}, @invalid_attrs)
    refute changeset.valid?
  end
end
