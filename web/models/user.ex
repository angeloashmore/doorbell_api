defmodule DoorbellApi.User do
  use DoorbellApi.Web, :model
  use Ecto.Model.Callbacks

  alias DoorbellApi.Repo
  alias DoorbellApi.GenUser
  alias DoorbellApi.Billing

  after_insert :create_gen_user
  after_insert :create_billing

  schema "users" do
    field :remote_id, :string
    field :email, :string
    field :name, :string

    has_one :gen_user, GenUser, on_delete: :fetch_and_delete
    has_one :billing, Billing, on_delete: :fetch_and_delete
    # has_many :chats, DoorbellApi.Chat, through: [:gen_user, :chats], on_delete: :delete_all
    # has_many :chat_participants, DoorbellApi.ChatParticipant, through: [:gen_user, :chat_participants], on_delete: :fetch_and_delete
    # has_many :chat_messages, DoorbellApi.ChatMessage, through: [:gen_user, :chat_messages], on_delete: :fetch_and_delete

    timestamps
  end

  @required_fields ~w(remote_id email name)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_format(:email, ~r/\A[^@]+@[^@]+\z/)
    |> unique_constraint(:remote_id, name: :users_remote_id_index)
    |> unique_constraint(:email, name: :users_email_index)
  end

  @spec create_billing(Ecto.Changeset) :: Ecto.Changeset
  defp create_billing(changeset) do
    build(changeset.model, :billing, email: changeset.model.email)
    |> Repo.insert!

    changeset
  end

  @spec create_gen_user(Ecto.Changeset) :: Ecto.Changeset
  defp create_gen_user(changeset) do
    build(changeset.model, :gen_user)
    |> Repo.insert!

    changeset
  end
end
