defmodule DoorbellApi.BillingController do
  use DoorbellApi.Web, :controller

  alias DoorbellApi.Billing

  plug :load_and_authorize_resource, model: Billing
  plug :halt_unauthorized_user

  def show(%{assigns: %{billing: billing}} = conn, _params) do
    render conn, "show.json", billing: billing
  end

  def update(%{assigns: %{billing: billing}} = conn, %{"billing" => billing_params}) do
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
