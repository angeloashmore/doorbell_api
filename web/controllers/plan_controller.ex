defmodule DoorbellApi.PlanController do
  use DoorbellApi.Web, :controller

  alias DoorbellApi.Plan

  plug :load_and_authorize_resource, model: Plan
  plug DoorbellApi.Plugs.Unauthorized

  def index(conn, _params) do
    plans = Repo.all(Plan)
    render(conn, "index.json", plans: plans)
  end

  def show(conn, %{"id" => id}) do
    plan = conn.assigns.plan
    render conn, "show.json", plan: plan
  end
end
