defmodule DoorbellApi.Repo.Migrations.CreateTeamMember do
  use Ecto.Migration

  def change do
    create table(:team_members) do
      add :user_id, :integer
      add :team_id, :integer
      add :title, :string
      add :email, :string
      add :private, :boolean, default: false
      add :roles_mask, :integer

      timestamps
    end

  end
end
