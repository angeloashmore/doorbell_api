defmodule DoorbellApi.ChatMessage do
  use DoorbellApi.Web, :model

  schema "chat_messages" do
    field :body, :string

    belongs_to :chat, DoorbellApi.Chat
    belongs_to :gen_user, DoorbellApi.GenUser

    timestamps
  end

  @required_fields ~w(chat_id gen_user_id body)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> foreign_key_constraint(:chat_id)
    |> foreign_key_constraint(:gen_user_id)
  end
end
