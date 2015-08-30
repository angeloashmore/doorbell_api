alias DoorbellApi.Repo
alias DoorbellApi.Plan

# Insert default plans.
%Plan{type: "user", name: "Default"} |> Repo.insert!
%Plan{type: "team", name: "Default"} |> Repo.insert!
