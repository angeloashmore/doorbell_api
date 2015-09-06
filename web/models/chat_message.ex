defmodule DoorbellApi.ChatMessage do
  use DoorbellApi.Web, :model

  schema "chat_messages" do
    field :body, :string

    belongs_to :chat, DoorbellApi.Chat
    belongs_to :user, DoorbellApi.User
    belongs_to :team_member, DoorbellApi.User

    timestamps
  end

  @required_fields ~w(chat_id body)
  @optional_fields ~w(user_id team_member_id)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  @doc """
  Returns the type of chat message (`:user` or `:team_member`). Returns
  `:unknown` if neither `user_id` nor `team_member_id` is set.
  """
  @spec type(ChatMessage) :: atom
  def type(%ChatMessage{user_id: user_id})
    when not is_nil(user_id), do: :user
  def type(%ChatMessage{team_member_id: team_member_id})
    when not is_nil(team_member_id), do: :team_member
  def type(%ChatMessage{}), do: :unknown
end
