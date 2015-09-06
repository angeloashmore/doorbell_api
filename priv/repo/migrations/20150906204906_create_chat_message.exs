defmodule DoorbellApi.Repo.Migrations.CreateChatMessage do
  use Ecto.Migration

  def change do
    create table(:chat_messages) do
      add :chat_id, :integer
      add :user_id, :integer
      add :team_user_id, :integer
      add :body, :string

      timestamps
    end

  end
end
