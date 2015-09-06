defmodule DoorbellApi.TeamUser do
  use DoorbellApi.Web, :model

  schema "team_users" do
    field :title, :string
    field :email, :string
    field :private, :boolean, default: false
    field :roles, {:array, :string}

    belongs_to :user, DoorbellApi.User
    belongs_to :team, DoorbellApi.Team

    has_many :chat_participants, DoorbellApi.ChatParticipant, on_delete: :delete_all

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
    |> validate_format(:email, ~r/\A[^@]+@[^@]+\z/)
    |> validate_subset(:roles, ["owner", "admin", "billing"])
  end
end
