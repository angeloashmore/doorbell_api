defmodule DoorbellApi.PlanController do
  use DoorbellApi.Web, :controller

  alias DoorbellApi.Plan

  plug :scrub_params, "plan" when action in [:create, :update]

  def index(conn, _params) do
    plans = Repo.all(Plan)
    render(conn, "index.json", plans: plans)
  end

  def create(conn, %{"plan" => plan_params}) do
    changeset = Plan.changeset(%Plan{}, plan_params)

    case Repo.insert(changeset) do
      {:ok, plan} ->
        conn
        |> put_status(:created)
        |> render("show.json", plan: plan)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(DoorbellApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    plan = Repo.get!(Plan, id)
    render conn, "show.json", plan: plan
  end

  def update(conn, %{"id" => id, "plan" => plan_params}) do
    plan = Repo.get!(Plan, id)
    changeset = Plan.changeset(plan, plan_params)

    case Repo.update(changeset) do
      {:ok, plan} ->
        render(conn, "show.json", plan: plan)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(DoorbellApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    plan = Repo.get!(Plan, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    plan = Repo.delete!(plan)

    send_resp(conn, :no_content, "")
  end
end
