defmodule DoorbellApi.Plan do
  use DoorbellApi.Web, :model

  alias DoorbellApi.Plan
  alias DoorbellApi.Repo

  schema "plans" do
    field :name, :string
    field :type, :string

    has_many :billings, DoorbellApi.Billing

    timestamps
  end

  @required_fields ~w(name type)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_inclusion(:type, ["user", "team"])
  end

  @doc """
  Returns the default plan model for the given `type`.
  """
  @spec default_for_type!(atom) :: Plan
  def default_for_type!(:user), do: Repo.get_by!(Plan, type: "user", name: "Default")
  def default_for_type!(:team), do: Repo.get_by!(Plan, type: "team", name: "Default")
end
