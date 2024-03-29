alias DoorbellApi.Repo
alias DoorbellApi.Plan
alias DoorbellApi.User
alias DoorbellApi.Team
alias DoorbellApi.TeamMember

# Insert default plans
%Plan{type: "user", name: "Default"} |> Repo.insert!
%Plan{type: "team", name: "Default"} |> Repo.insert!

# Insert default testing models
if System.get_env("MIX_ENV") == "test" do
  user = %User{remote_id: "remote_1", email: "name@example.com", name: "Example User"}
  |> Repo.insert!

  team = %Team{name: "Example Team", email: "name@example.com"}
  |> Repo.insert!
end
