defmodule DoorbellApi.TeamController do
  use DoorbellApi.Web, :controller

  alias DoorbellApi.Team

  plug :load_and_authorize_resource, model: Team
  plug DoorbellApi.Plugs.Unauthorized

  def index(conn, _params) do
    teams = Repo.all(Team)
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

  def show(conn, %{"id" => id}) do
    team = conn.assigns.team
    render conn, "show.json", team: team
  end

  def update(conn, %{"id" => id, "team" => team_params}) do
    team = conn.assigns.team
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

  def delete(conn, %{"id" => id}) do
    team = conn.assigns.team

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    team = Repo.delete!(team)

    send_resp(conn, :no_content, "")
  end
end
