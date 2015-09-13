defmodule DoorbellApi.TeamController do
  use DoorbellApi.Web, :controller

  alias DoorbellApi.Team

  plug :authorize_resource, model: Team
  plug :load_resource, model: Team, except: :index, preload: :team_users
  plug :halt_unauthorized_user

  def index(conn, %{"query" => query}) do
    query = from t in Team,
      where: like(t.name, "%" <> query <> "%"),
      preload: :team_users

    teams = Repo.all(query)
    render(conn, "index.json", teams: teams)
  end
  def index(conn, _params) do
    query = from t in Team,
      join: tm in assoc(t, :team_users),
      where: tm.user_id == ^conn.assigns.current_user.id,
      select: t,
      preload: :team_users
    teams = Repo.all(query)
    render(conn, "index.json", teams: teams)
  end

  def create(conn, %{"team" => team_params}) do
    changeset = Team.changeset(%Team{}, team_params)

    case Repo.insert(changeset) do
      {:ok, team} ->
        team = Repo.preload(team, :team_users)

        conn
        |> put_status(:created)
        |> render("show.json", team: team)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(DoorbellApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(%{assigns: %{team: team}} = conn, _params) do
    render conn, "show.json", team: team
  end

  def update(%{assigns: %{team: team}} = conn, %{"team" => team_params}) do
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

  def delete(%{assigns: %{team: team}} = conn, _params) do
    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(team)

    send_resp(conn, :no_content, "")
  end
end
