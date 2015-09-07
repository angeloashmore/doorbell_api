defmodule DoorbellApi.GenUser do
  use DoorbellApi.Web, :model

  alias DoorbellApi.GenUser

  schema "gen_users" do
    belongs_to :user, DoorbellApi.User
    belongs_to :team_user, DoorbellApi.TeamUser

    has_many :chats, DoorbellApi.Chat, on_delete: :fetch_and_delete
    has_many :chat_messages, DoorbellApi.ChatMessage, on_delete: :fetch_and_delete

    timestamps
  end

  @required_fields ~w()
  @optional_fields ~w(user_id team_user_id)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:team_user_id)
    |> unique_constraint(:user_id, name: :gen_users_user_id_index)
    |> unique_constraint(:team_user_id, name: :gen_users_team_user_id_index)
    # |> validate_association
  end

  @doc """
  Returns the type of generic user (`:user` or `:team_user`). Returns
  `:unknown` if neither `user_id` nor `team_user_id` is set.
  """
  @spec type(GenUser) :: atom
  def type(%GenUser{user_id: user_id})
    when not is_nil(user_id), do: :user
  def type(%GenUser{team_user_id: team_user_id})
    when not is_nil(team_user_id), do: :team_user
  def type(%GenUser{}), do: :unknown

  # TODO: Validate the association only if the changeset includes user_id or
  #       team_user_id
  #
  # @spec validate_association(Ecto.Changeset.t) :: Ecto.Changeset.t
  # defp validate_association(%{model: %{user_id: user_id, team_user_id: team_user_id}} = changeset)
  #   when is_nil(user_id) and is_nil(team_user_id) do
  #   add_error(changeset, :user_id, "user_id or team_id must be set")
  # end
  # defp validate_association(%{model: %{user_id: user_id, team_user_id: team_user_id}} = changeset)
  #   when not is_nil(user_id) and not is_nil(team_user_id) do
  #   add_error(changeset, :user_id, "user_id or team_id must be set, but not both")
  # end
  # defp validate_association(changeset), do: changeset
end
