defmodule DoorbellApi.Repo.Migrations.CreateTeamUser do
  use Ecto.Migration

  def change do
    create table(:team_users) do
      add :user_id, references(:users)
      add :team_id, references(:teams)
      add :title, :string
      add :email, :string
      add :private, :boolean, default: false
      add :roles, {:array, :string}

      timestamps
    end
    create unique_index(:team_users, [:user_id, :team_id])

  end
end
