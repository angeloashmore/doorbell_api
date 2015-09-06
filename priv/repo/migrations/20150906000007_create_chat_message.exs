defmodule DoorbellApi.Repo.Migrations.CreateChatMessage do
  use Ecto.Migration

  def change do
    create table(:chat_messages) do
      add :chat_id, references(:chats)
      add :chat_participant_id, references(:chat_participants)
      add :body, :string

      timestamps
    end
    create index(:chat_messages, [:chat_id])
    create index(:chat_messages, [:chat_participant_id])

  end
end
