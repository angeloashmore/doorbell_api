defimpl Canada.Can, for: DoorbellApi.User do
  alias DoorbellApi.Repo
  alias DoorbellApi.Billing
  alias DoorbellApi.Chat
  alias DoorbellApi.ChatParticipant
  alias DoorbellApi.Plan
  alias DoorbellApi.Team
  alias DoorbellApi.TeamUser
  alias DoorbellApi.User
  alias DoorbellApi.GenUser

  # Billing (User)
  def can?(%User{id: user_id}, action, %Billing{user_id: user_id})
    when action in [:show, :update] and not is_nil(user_id), do: true

  # Billing (Team)
  def can?(%User{} = user, action, %Billing{team_id: team_id})
    when action in [:show, :update] and not is_nil(team_id),
    do: has_roles_for_team?(user, %Team{id: team_id}, ["owner", "billing"])

  # Chat
  def can?(%User{}, action, Chat) when action in [:index, :create], do: true
  def can?(%User{gen_user: gen_user} = user, :show, %Chat{} = chat),
    do: is_participant_of_chat?(gen_user, chat)
  def can?(%User{gen_user: %{id: gen_user_id}}, action, %Chat{gen_user_id: gen_user_id})
    when action in [:update, :delete], do: true

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

  @spec is_participant_of_chat?(GenUser, Chat) :: boolean
  defp is_participant_of_chat?(%GenUser{id: gen_user_id}, %Chat{id: chat_id}) do
    !is_nil Repo.get_by(ChatParticipant, chat_id: chat_id, gen_user_id: gen_user_id)
  end
  defp is_participant_of_chat?(_, _), do: false

  @spec is_user_of_team?(User, Team) :: boolean
  defp is_user_of_team?(%User{id: user_id}, %Team{id: team_id})
    when not is_nil(team_id) do
    !is_nil Repo.get_by(TeamUser, team_id: team_id, user_id: user_id)
  end
  defp is_user_of_team?(_, _), do: false

  @spec has_roles_for_team?(User, Team, [String.t]) :: boolean
  defp has_roles_for_team?(%User{id: user_id}, %Team{id: team_id}, roles)
    when not is_nil(team_id) do
    (Repo.get_by(TeamUser, team_id: team_id, user_id: user_id) || %{})
    |> Map.get(:roles, [])
    |> Enum.any? fn x -> x in roles end
  end
  defp has_roles_for_team?(_, _, _), do: false
end
