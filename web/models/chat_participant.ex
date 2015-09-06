defmodule DoorbellApi.ChatParticipant do
  use DoorbellApi.Web, :model

  alias DoorbellApi.ChatParticipant

  schema "chat_participants" do
    belongs_to :chat, DoorbellApi.Chat
    belongs_to :user, DoorbellApi.User
    belongs_to :team_user, DoorbellApi.TeamUser

    has_many :chat_messages, DoorbellApi.ChatMessage, on_delete: :delete_all

    timestamps
  end

  @required_fields ~w(chat_id)
  @optional_fields ~w(user_id team_user_id)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> foreign_key_constraint(:chat_id)
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:team_user_id)
  end

  @doc """
  Returns the type of chat participant (`:user` or `:team_user`). Returns
  `:unknown` if neither `user_id` nor `team_user_id` is set.
  """
  @spec type(ChatParticipant) :: atom
  def type(%ChatParticipant{user_id: user_id})
    when not is_nil(user_id), do: :user
  def type(%ChatParticipant{team_user_id: team_user_id})
    when not is_nil(team_user_id), do: :team_user
  def type(%ChatParticipant{}), do: :unknown
end
