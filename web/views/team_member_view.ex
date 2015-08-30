defmodule DoorbellApi.TeamMemberView do
  use DoorbellApi.Web, :view

  def render("index.json", %{team_members: team_members}) do
    %{data: render_many(team_members, DoorbellApi.TeamMemberView, "team_member.json")}
  end

  def render("show.json", %{team_member: team_member}) do
    %{data: render_one(team_member, DoorbellApi.TeamMemberView, "team_member.json")}
  end

  def render("team_member.json", %{team_member: team_member}) do
    %{id: team_member.id,
      user_id: team_member.user_id,
      team_id: team_member.team_id,
      title: team_member.title,
      email: team_member.email,
      private: team_member.private,
      roles_mask: team_member.roles_mask}
  end
end
