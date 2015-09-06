defmodule DoorbellApi.Chat do
  use DoorbellApi.Web, :model

  schema "chats" do
    field :name, :string

    has_many :chat_messages, DoorbellApi.ChatMessage, on_delete: :delete_all
    has_many :chat_messages_users, through: [:chat_messages, :user]
    has_many :chat_messages_team_members, through: [:chat_messages, :team_members]

    timestamps
  end

  @required_fields ~w(name)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
