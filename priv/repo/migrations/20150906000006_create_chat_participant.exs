defmodule DoorbellApi.Repo.Migrations.CreateChatParticipant do
  use Ecto.Migration

  def change do
    create table(:chat_participants) do
      add :chat_id, references(:chats)
      add :user_id, references(:users)
      add :team_user_id, references(:team_users)

      timestamps
    end
    create index(:chat_participants, [:chat_id])
    create index(:chat_participants, [:user_id])
    create index(:chat_participants, [:team_user_id])

  end
end
