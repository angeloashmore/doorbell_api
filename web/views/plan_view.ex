defmodule DoorbellApi.PlanView do
  use DoorbellApi.Web, :view

  def render("index.json", %{plans: plans}) do
    %{data: render_many(plans, DoorbellApi.PlanView, "plan.json")}
  end

  def render("show.json", %{plan: plan}) do
    %{data: render_one(plan, DoorbellApi.PlanView, "plan.json")}
  end

  def render("plan.json", %{plan: plan}) do
    %{id: plan.id,
      name: plan.name,
      type: plan.type}
  end
end
