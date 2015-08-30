defmodule DoorbellApi.TeamView do
  use DoorbellApi.Web, :view

  def render("index.json", %{teams: teams}) do
    %{data: render_many(teams, DoorbellApi.TeamView, "team.json")}
  end

  def render("show.json", %{team: team}) do
    %{data: render_one(team, DoorbellApi.TeamView, "team.json")}
  end

  def render("team.json", %{team: team}) do
    %{id: team.id,
      name: team.name,
      email: team.email}
  end
end
