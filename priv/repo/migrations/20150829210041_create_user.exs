defmodule DoorbellApi.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :remote_id, :string
      add :email, :string
      add :name, :string

      timestamps
    end

  end
end
