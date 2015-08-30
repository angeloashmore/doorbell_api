defmodule DoorbellApi.BillingController do
  use DoorbellApi.Web, :controller

  alias DoorbellApi.Billing

  plug :scrub_params, "billing" when action in [:create, :update]

  def index(conn, _params) do
    billings = Repo.all(Billing)
    render(conn, "index.json", billings: billings)
  end

  def create(conn, %{"billing" => billing_params}) do
    changeset = Billing.changeset(%Billing{}, billing_params)

    case Repo.insert(changeset) do
      {:ok, billing} ->
        conn
        |> put_status(:created)
        |> render("show.json", billing: billing)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(DoorbellApi.ChangesetView, "error.json", changeset: changeset)
    end
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

  def delete(conn, %{"id" => id}) do
    billing = Repo.get!(Billing, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    billing = Repo.delete!(billing)

    send_resp(conn, :no_content, "")
  end
end
