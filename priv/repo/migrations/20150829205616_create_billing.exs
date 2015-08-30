defmodule DoorbellApi.Repo.Migrations.CreateBilling do
  use Ecto.Migration

  def change do
    create table(:billings) do
      add :plan_id, :integer
      add :user_id, :integer
      add :team_id, :integer
      add :stripe_customer_id, :string
      add :email, :string
      add :brand, :string
      add :last4, :string
      add :exp_month, :string
      add :exp_year, :string

      timestamps
    end

  end
end
