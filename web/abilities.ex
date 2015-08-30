defimpl Canada.Can, for: DoorbellApi.User do
  use DoorbellApi.Web, :abilities

  # Billing (User)
  def can?(%User{id: user_id}, action, %Billing{user_id: user_id})
    when action in [:show, :update], do: true

  # Billing (Team)
  def can?(%User{} = user, :show, %Billing{team_id: team_id}),
    do: is_member_of_team?(user, %Team{id: team_id})
  def can?(%User{} = user, :update, %Billing{team_id: team_id}),
    do: has_roles_for_team?(user, %Team{id: team_id}, ["owner", "billing"])

  # Plan
  def can?(%User{}, :show, %Plan{}), do: true

  # Team
  def can?(%User{}, :create, %Team{}),
    do: true
  def can?(%User{} = user, :show, %Team{} = team),
    do: is_member_of_team?(user, team)
  def can?(%User{} = user, :update, %Team{} = team),
    do: has_roles_for_team?(user, team, ["owner", "admin"])
  def can?(%User{} = user, :delete, %Team{} = team),
    do: has_roles_for_team?(user, team, ["owner"])

  # Team Member
  def can?(%User{} = user, :show, %TeamMember{team_id: team_id}),
    do: is_member_of_team?(user, %Team{id: team_id})
  def can?(%User{} = user, action, %TeamMember{team_id: team_id})
    when action in [:create, :update, :delete],
    do: has_roles_for_team?(user, %Team{id: team_id}, ["owner", "admin"])

  # User
  def can?(%User{id: user_id}, action, %User{id: user_id})
    when action in [:show, :update], do: true

  # Default all other actions to false
  def can?(%User{}, _, _), do: false

  defp is_member_of_team?(%User{id: user_id}, %Team{id: team_id}) do
    !is_nil Repo.get_by(TeamMember, team_id: team_id, user_id: user_id)
  end

  defp has_roles_for_team?(%User{id: user_id}, %Team{id: team_id}, roles) do
    Repo.get_by(TeamMember, team_id: team_id, user_id: user_id) || %{}
    |> Map.get(:roles, [])
    |> Enum.any? fn x -> x in roles end
  end
end
