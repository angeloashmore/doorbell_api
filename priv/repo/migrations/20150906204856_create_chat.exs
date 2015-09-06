defmodule DoorbellApi.Repo.Migrations.CreateChat do
  use Ecto.Migration

  def change do
    create table(:chats) do
      add :place_id, :string

      timestamps
    end

  end
end
