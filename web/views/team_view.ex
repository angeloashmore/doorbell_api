defmodule DoorbellApi.TeamView do
  use DoorbellApi.Web, :view

  alias DoorbellApi.TeamMemberView

  def render("index.json", %{teams: teams}) do
    %{data: render_many(teams, DoorbellApi.TeamView, "team.json")}
  end

  def render("show.json", %{team: team}) do
    %{data: render_one(team, DoorbellApi.TeamView, "team.json")}
  end

  def render("team.json", %{team: team}) do
    team_members = team.team_members
    |> Enum.map &(TeamMemberView.render("team_member.json", %{team_member: &1}))

    %{id: team.id,
      name: team.name,
      email: team.email,
      team_members: team_members}
  end
end
