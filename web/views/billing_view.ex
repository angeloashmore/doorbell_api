defmodule DoorbellApi.BillingView do
  use DoorbellApi.Web, :view

  def render("index.json", %{billings: billings}) do
    %{data: render_many(billings, DoorbellApi.BillingView, "billing.json")}
  end

  def render("show.json", %{billing: billing}) do
    %{data: render_one(billing, DoorbellApi.BillingView, "billing.json")}
  end

  def render("billing.json", %{billing: billing}) do
    %{id: billing.id,
      plan_id: billing.plan_id,
      relation_type: billing.relation_type,
      relation_id: billing.relation_id,
      stripe_customer_id: billing.stripe_customer_id,
      email: billing.email,
      brand: billing.brand,
      last4: billing.last4,
      exp_month: billing.exp_month,
      exp_year: billing.exp_year}
  end
end
