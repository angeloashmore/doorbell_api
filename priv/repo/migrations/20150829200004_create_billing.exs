defmodule DoorbellApi.Repo.Migrations.CreateBilling do
  use Ecto.Migration

  def change do
    create table(:billings) do
      add :plan_id, references(:plans)
      add :user_id, references(:users)
      add :team_id, references(:teams)
      add :stripe_customer_id, :string
      add :email, :string
      add :brand, :string
      add :last4, :string
      add :exp_month, :string
      add :exp_year, :string

      timestamps
    end
    create unique_index(:billings, [:user_id])
    create unique_index(:billings, [:team_id])
    create index(:billings, [:plan_id])

  end
end
