defmodule DoorbellApi.Repo.Migrations.CreateChat do
  use Ecto.Migration

  def change do
    create table(:chats) do
      add :gen_user_id, references(:gen_users)
      add :place_id, :string

      timestamps
    end
    create index(:chats, [:gen_user_id])
    create index(:chats, [:place_id])

  end
end
