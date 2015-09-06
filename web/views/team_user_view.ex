defmodule DoorbellApi.TeamUserView do
  use DoorbellApi.Web, :view

  def render("index.json", %{team_users: team_users}) do
    %{data: render_many(team_users, DoorbellApi.TeamUserView, "team_user.json")}
  end

  def render("show.json", %{team_user: team_user}) do
    %{data: render_one(team_user, DoorbellApi.TeamUserView, "team_user.json")}
  end

  def render("team_user.json", %{team_user: team_user}) do
    %{id: team_user.id,
      user_id: team_user.user_id,
      team_id: team_user.team_id,
      title: team_user.title,
      email: team_user.email,
      private: team_user.private,
      roles: team_user.roles}
  end
end
