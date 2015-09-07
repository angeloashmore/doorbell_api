defmodule DoorbellApi.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :remote_id, :string
      add :email, :string
      add :name, :string

      timestamps
    end
    create unique_index(:users, [:remote_id])
    create unique_index(:users, [:email])

  end
end
