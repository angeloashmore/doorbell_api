defmodule DoorbellApi.Team do
  use DoorbellApi.Web, :model
  use Ecto.Model.Callbacks

  alias DoorbellApi.Repo
  alias DoorbellApi.Billing
  alias DoorbellApi.TeamMember

  after_insert :create_billing

  schema "teams" do
    field :name, :string
    field :email, :string

    has_one :billing, Billing
    has_many :team_members, TeamMember

    timestamps
  end

  @required_fields ~w(name email)
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
  end

  @spec create_billing(Ecto.Changeset) :: Ecto.Changeset
  defp create_billing(changeset) do
    %{model: %{id: id, email: email}} = changeset

    %Billing{team_id: id, email: email}
    |> Repo.insert!

    changeset
  end
end
