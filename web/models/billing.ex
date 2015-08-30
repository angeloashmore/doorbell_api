defmodule DoorbellApi.Billing do
  use DoorbellApi.Web, :model
  use Ecto.Model.Callbacks

  alias DoorbellApi.Plan
  alias DoorbellApi.User
  alias DoorbellApi.Team
  alias DoorbellApi.Billing

  before_insert :set_default_plan
  before_insert :create_stripe_customer

  schema "billings" do
    field :stripe_customer_id, :string
    field :email, :string
    field :brand, :string
    field :last4, :string
    field :exp_month, :string
    field :exp_year, :string

    belongs_to :plan, Plan
    belongs_to :user, User
    belongs_to :team, Team

    timestamps
  end

  @required_fields ~w(plan_id email)
  @optional_fields ~w(user_id team_id stripe_customer_id brand last4 exp_month exp_year)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_format(:email, ~r/\A[^@]+@[^@]+\z/)
    |> validate_format(:stripe_customer_id, ~r/^cus_/)
  end

  @doc """
  Returns the type of billing (`:user` or `:team`). Returns `:unknown` if
  neither `user_id` nor `team_id` is set.
  """
  @spec type(Billing) :: atom
  def type(%Billing{user_id: user_id}) when not is_nil(user_id), do: :user
  def type(%Billing{team_id: team_id}) when not is_nil(team_id), do: :team
  def type(%Billing{}), do: :unknown

  defp set_default_plan(changeset) do
    plan = Billing.type(changeset.model)
    |> Plan.default_for!

    change(changeset, plan_id: plan.id)
  end

  @spec create_stripe_customer(Ecto.Changeset) :: Ecto.Changeset
  defp create_stripe_customer(changeset) do
    # %{model: %{email: email}} = changeset
    # %{id: id} = Stripe.Customers.create(%{email: email})
    change(changeset, stripe_customer_id: "cus_mockID")
  end
end
