defimpl Canada.Can, for: DoorbellApi.User do
  alias DoorbellApi.Repo
  alias DoorbellApi.Billing
  alias DoorbellApi.Plan
  alias DoorbellApi.Team
  alias DoorbellApi.TeamUser
  alias DoorbellApi.User

  # Billing (User)
  def can?(%User{id: user_id}, action, %Billing{user_id: user_id})
    when action in [:show, :update] and not is_nil(user_id), do: true

  # Billing (Team)
  def can?(%User{} = user, action, %Billing{team_id: team_id})
    when action in [:show, :update] and not is_nil(team_id),
    do: has_roles_for_team?(user, %Team{id: team_id}, ["owner", "billing"])

  # Plan
  def can?(%User{}, :index, Plan), do: true
  def can?(%User{}, :show, %Plan{}), do: true

  # Team
  def can?(%User{}, action, Team) when action in [:index, :create], do: true
  def can?(%User{} = user, :show, %Team{} = team),
    do: is_user_of_team?(user, team)
  def can?(%User{} = user, :update, %Team{} = team),
    do: has_roles_for_team?(user, team, ["owner", "admin"])
  def can?(%User{} = user, :delete, %Team{} = team),
    do: has_roles_for_team?(user, team, ["owner"])

  # Team User
  def can?(%User{}, :create, TeamUser), do: true
  def can?(%User{} = user, :show, %TeamUser{team_id: team_id}),
    do: is_user_of_team?(user, %Team{id: team_id})
  def can?(%User{} = user, action, %TeamUser{team_id: team_id})
    when action in [:update, :delete],
    do: has_roles_for_team?(user, %Team{id: team_id}, ["owner", "admin"])

  # User
  def can?(%User{id: user_id}, action, %User{id: user_id})
    when action in [:show, :update], do: true

  # Default all other actions to false
  def can?(%User{}, _, _), do: false

  defp is_user_of_team?(%User{id: user_id}, %Team{id: team_id})
    when not is_nil(team_id) do
    !is_nil Repo.get_by(TeamUser, team_id: team_id, user_id: user_id)
  end
  defp is_user_of_team?(_, _), do: false

  defp has_roles_for_team?(%User{id: user_id}, %Team{id: team_id}, roles)
    when not is_nil(team_id) do
    (Repo.get_by(TeamUser, team_id: team_id, user_id: user_id) || %{})
    |> Map.get(:roles, [])
    |> Enum.any? fn x -> x in roles end
  end
  defp has_roles_for_team?(_, _, _), do: false
end
