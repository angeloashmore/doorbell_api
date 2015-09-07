defmodule DoorbellApi.TeamUser do
  use DoorbellApi.Web, :model
  use Ecto.Model.Callbacks

  alias DoorbellApi.Repo

  after_insert :create_gen_user

  schema "team_users" do
    field :title, :string
    field :email, :string
    field :private, :boolean, default: false
    field :roles, {:array, :string}

    belongs_to :user, DoorbellApi.User
    belongs_to :team, DoorbellApi.Team

    has_one :gen_user, DoorbellApi.GenUser, on_delete: :delete_all
    # has_many :chats, DoorbellApi.Chat, through: [:gen_user, :chats], on_delete: :delete_all
    # has_many :chat_participants, DoorbellApi.ChatParticipant, through: [:gen_user, :chat_participants], on_delete: :fetch_and_delete
    # has_many :chat_messages, DoorbellApi.ChatMessage, through: [:gen_user, :chat_messages], on_delete: :fetch_and_delete

    timestamps
  end

  @required_fields ~w(user_id team_id title email private roles)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:team_id)
    |> unique_constraint(:user_id, name: :team_users_user_id_team_id_index)
    |> validate_format(:email, ~r/\A[^@]+@[^@]+\z/)
    |> validate_subset(:roles, ["owner", "admin", "billing"])
  end

  @spec create_gen_user(Ecto.Changeset.t) :: Ecto.Changeset.t
  defp create_gen_user(changeset) do
    build(changeset.model, :gen_user)
    |> Repo.insert!

    changeset
  end
end
