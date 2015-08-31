defimpl Canada.Can, for: DoorbellApi.User do
  import Ecto.Query, only: [from: 1, from: 2]

  alias DoorbellApi.Repo
  alias DoorbellApi.Billing
  alias DoorbellApi.Plan
  alias DoorbellApi.Team
  alias DoorbellApi.TeamMember
  alias DoorbellApi.User

  # Billing
  def can?(%User{}, :index, Billing), do: true

  # Billing (User)
  def can?(%User{id: user_id}, action, %Billing{user_id: user_id})
    when action in [:show, :update] and not is_nil(user_id), do: true

  # Billing (Team)
  def can?(%User{} = user, :show, %Billing{team_id: team_id})
    when not is_nil(team_id),
    do: is_member_of_team?(user, %Team{id: team_id})
  def can?(%User{} = user, :update, %Billing{team_id: team_id})
    when not is_nil(team_id),
    do: has_roles_for_team?(user, %Team{id: team_id}, ["owner", "billing"])

  # Plan
  def can?(%User{}, :index, Plan), do: true
  def can?(%User{}, :show, %Plan{}), do: true

  # Team
  def can?(%User{}, action, Team) when action in [:index, :create], do: true
  def can?(%User{} = user, :show, %Team{} = team),
    do: is_member_of_team?(user, team)
  def can?(%User{} = user, :update, %Team{} = team),
    do: has_roles_for_team?(user, team, ["owner", "admin"])
  def can?(%User{} = user, :delete, %Team{} = team),
    do: has_roles_for_team?(user, team, ["owner"])

  # Team Member
  def can?(%User{}, action, TeamMember) when action in [:index, :create], do: true
  def can?(%User{} = user, :show, %TeamMember{team_id: team_id}),
    do: is_member_of_team?(user, %Team{id: team_id})
  def can?(%User{} = user, action, %TeamMember{team_id: team_id})
    when action in [:update, :delete],
    do: has_roles_for_team?(user, %Team{id: team_id}, ["owner", "admin"])

  # User
  def can?(%User{}, action, User) when action in [:index, :create], do: true
  def can?(%User{id: user_id}, action, %User{id: user_id})
    when action in [:show, :update], do: true

  # Default all other actions to false
  def can?(%User{}, _action, _model), do: false

  defp is_member_of_team?(%User{id: user_id}, %Team{id: team_id})
    when not is_nil(team_id) do
    !is_nil Repo.get_by(TeamMember, team_id: team_id, user_id: user_id)
  end
  defp is_member_of_team?(_, _), do: false

  defp has_roles_for_team?(%User{id: user_id}, %Team{id: team_id}, roles)
    when not is_nil(team_id) do
    (Repo.get_by(TeamMember, team_id: team_id, user_id: user_id) || %{})
    |> Map.get(:roles, [])
    |> Enum.any? fn x -> x in roles end
  end
  defp has_roles_for_team?(_, _, _), do: false
end
