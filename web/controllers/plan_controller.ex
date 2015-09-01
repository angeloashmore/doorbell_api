defmodule DoorbellApi.PlanController do
  use DoorbellApi.Web, :controller

  alias DoorbellApi.Plan

  plug :load_and_authorize_resource, model: Plan
  plug :halt_unauthorized_user

  def index(%{assigns: %{plans: plans}} = conn, _params) do
    render(conn, "index.json", plans: plans)
  end

  def show(%{assigns: %{plan: plan}} = conn, _params) do
    render conn, "show.json", plan: plan
  end
end
