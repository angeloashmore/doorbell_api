defmodule DoorbellApi.Repo.Migrations.CreateGenUser do
  use Ecto.Migration

  def change do
    create table(:gen_users) do
      add :user_id, references(:users)
      add :team_user_id, references(:team_users)

      timestamps
    end
    create unique_index(:gen_users, [:user_id])
    create unique_index(:gen_users, [:team_user_id])

  end
end
