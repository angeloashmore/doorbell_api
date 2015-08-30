defmodule DoorbellApi.PlanController do
  use DoorbellApi.Web, :controller

  alias DoorbellApi.Plan

  plug Joken.Plug, on_verifying: &JokenConfig.on_verifying/0, on_error: &JokenConfig.on_error/2

  def index(conn, _params) do
    plans = Repo.all(Plan)
    render(conn, "index.json", plans: plans)
  end

  def show(conn, %{"id" => id}) do
    plan = Repo.get!(Plan, id)
    render conn, "show.json", plan: plan
  end
end
