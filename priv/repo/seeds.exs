alias DoorbellApi.Repo
alias DoorbellApi.Plan
alias DoorbellApi.User
alias DoorbellApi.Team
alias DoorbellApi.TeamUser

# Insert default plans
%Plan{type: "user", name: "Default"} |> Repo.insert!
%Plan{type: "team", name: "Default"} |> Repo.insert!

# Insert default testing models
if Mix.env == :test do
  user = %User{remote_id: "remote_1", email: "name@example.com", name: "Example User"}
  |> Repo.insert!

  team = %Team{name: "Example Team", email: "name@example.com"}
  |> Repo.insert!

  %TeamUser{team_id: team.id, user_id: user.id, email: "name@example.com", roles: ["owner"]}
  |> Repo.insert!
end
