defmodule DoorbellApi.BillingController do
  use DoorbellApi.Web, :controller

  alias DoorbellApi.User
  alias DoorbellApi.Billing

  def index(conn, _params) do
    billings = Repo.all(Billing)
    render(conn, "index.json", billings: billings)
  end

  def show(conn, %{"id" => id}) do
    billing = Repo.get!(Billing, id)
    render conn, "show.json", billing: billing
  end

  def update(conn, %{"id" => id, "billing" => billing_params}) do
    billing = Repo.get!(Billing, id)
    changeset = Billing.changeset(billing, billing_params)

    case Repo.update(changeset) do
      {:ok, billing} ->
        render(conn, "show.json", billing: billing)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(DoorbellApi.ChangesetView, "error.json", changeset: changeset)
    end
  end
end
