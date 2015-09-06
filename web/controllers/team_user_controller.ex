defmodule DoorbellApi.TeamUserController do
  use DoorbellApi.Web, :controller

  alias DoorbellApi.TeamUser

  plug :load_and_authorize_resource, model: TeamUser
  plug :halt_unauthorized_user

  def create(conn, %{"team_user" => team_user_params}) do
    changeset = TeamUser.changeset(%TeamUser{}, team_user_params)

    case Repo.insert(changeset) do
      {:ok, team_user} ->
        conn
        |> put_status(:created)
        |> render("show.json", team_user: team_user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(DoorbellApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(%{assigns: %{team_user: team_user}} = conn, _params) do
    render conn, "show.json", team_user: team_user
  end

  def update(%{assigns: %{team_user: team_user}} = conn, %{"team_user" => team_user_params}) do
    changeset = TeamUser.changeset(team_user, team_user_params)

    case Repo.update(changeset) do
      {:ok, team_user} ->
        render(conn, "show.json", team_user: team_user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(DoorbellApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(%{assigns: %{team_user: team_user}} = conn, _params) do
    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(team_user)

    send_resp(conn, :no_content, "")
  end
end
