defmodule DoorbellApi.Repo.Migrations.CreateChatMessage do
  use Ecto.Migration

  def change do
    create table(:chat_messages) do
      add :chat_id, references(:chats)
      add :gen_user_id, references(:gen_users)
      add :body, :string

      timestamps
    end
    create index(:chat_messages, [:chat_id])
    create index(:chat_messages, [:gen_user_id])

  end
end
