defmodule DoorbellApi.Chat do
  use DoorbellApi.Web, :model

  schema "chats" do
    field :place_id, :string

    has_many :chat_messages, DoorbellApi.ChatMessage, on_delete: :delete_all

    timestamps
  end

  @required_fields ~w(place_id)
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
