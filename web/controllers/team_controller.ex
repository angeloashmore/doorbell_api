defmodule DoorbellApi.TeamController do
  use DoorbellApi.Web, :controller

  alias DoorbellApi.Team

  plug :load_and_authorize_resource, model: Team
  plug DoorbellApi.Plugs.Unauthorized

  def index(%{assigns: %{teams: teams}} = conn, _params) do
    render(conn, "index.json", teams: teams)
  end

  def create(conn, %{"team" => team_params}) do
    changeset = Team.changeset(%Team{}, team_params)

    case Repo.insert(changeset) do
      {:ok, team} ->
        conn
        |> put_status(:created)
        |> render("show.json", team: team)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(DoorbellApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(%{assigns: %{team: team}} = conn, %{"id" => id}) do
    render conn, "show.json", team: team
  end

  def update(%{assigns: %{team: team}} = conn, %{"id" => id, "team" => team_params}) do
    changeset = Team.changeset(team, team_params)

    case Repo.update(changeset) do
      {:ok, team} ->
        render(conn, "show.json", team: team)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(DoorbellApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(%{assigns: %{team: team}} = conn, %{"id" => id}) do
    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    team = Repo.delete!(team)

    send_resp(conn, :no_content, "")
  end
end
