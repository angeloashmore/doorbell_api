defmodule DoorbellApi.Chat do
  use DoorbellApi.Web, :model

  schema "chats" do
    field :place_id, :string

    belongs_to :gen_user, DoorbellApi.GenUser
    has_many :chat_participants, DoorbellApi.ChatParticipant, on_delete: :fetch_and_delete
    has_many :chat_messages, DoorbellApi.ChatMessage, on_delete: :fetch_and_delete

    timestamps
  end

  @required_fields ~w(place_id gen_user_id)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> foreign_key_constraint(:gen_user_id)
  end
end
