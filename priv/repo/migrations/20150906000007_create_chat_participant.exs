defmodule DoorbellApi.Repo.Migrations.CreateChatParticipant do
  use Ecto.Migration

  def change do
    create table(:chat_participants) do
      add :chat_id, references(:chats)
      add :gen_user_id, references(:gen_users)

      timestamps
    end
    create unique_index(:chat_participants, [:gen_user_id, :chat_id])

  end
end
