defmodule DoorbellApi.User do
  use DoorbellApi.Web, :model
  use Ecto.Model.Callbacks

  alias DoorbellApi.Repo
  alias DoorbellApi.Billing

  after_insert :create_billing

  schema "users" do
    field :remote_id, :string
    field :email, :string
    field :name, :string

    has_one :billing, Billing, on_delete: :delete_all

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
  end

  @spec create_billing(Ecto.Changeset) :: Ecto.Changeset
  defp create_billing(changeset) do
    %{model: %{id: id, email: email}} = changeset

    %Billing{user_id: id, email: email}
    |> Repo.insert!

    changeset
  end
end
