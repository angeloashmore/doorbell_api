defmodule DoorbellApi.TeamView do
  use DoorbellApi.Web, :view

  alias DoorbellApi.TeamUserView

  def render("index.json", %{teams: teams}) do
    %{data: render_many(teams, DoorbellApi.TeamView, "team.json")}
  end

  def render("show.json", %{team: team}) do
    %{data: render_one(team, DoorbellApi.TeamView, "team.json")}
  end

  def render("team.json", %{team: team}) do
    team_users = team.team_users
    |> Enum.map &(TeamUserView.render("team_user.json", %{team_user: &1}))

    %{id: team.id,
      name: team.name,
      email: team.email,
      team_users: team_users}
  end
end
