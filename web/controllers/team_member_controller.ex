defmodule DoorbellApi.TeamMemberController do
  use DoorbellApi.Web, :controller

  alias DoorbellApi.TeamMember

  plug :load_and_authorize_resource, model: TeamMember
  plug :halt_unauthorized_user

  def create(conn, %{"team_member" => team_member_params}) do
    changeset = TeamMember.changeset(%TeamMember{}, team_member_params)

    case Repo.insert(changeset) do
      {:ok, team_member} ->
        conn
        |> put_status(:created)
        |> render("show.json", team_member: team_member)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(DoorbellApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(%{assigns: %{team_member: team_member}} = conn, _params) do
    render conn, "show.json", team_member: team_member
  end

  def update(%{assigns: %{team_member: team_member}} = conn, %{"team_member" => team_member_params}) do
    changeset = TeamMember.changeset(team_member, team_member_params)

    case Repo.update(changeset) do
      {:ok, team_member} ->
        render(conn, "show.json", team_member: team_member)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(DoorbellApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(%{assigns: %{team_member: team_member}} = conn, _params) do
    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(team_member)

    send_resp(conn, :no_content, "")
  end
end
