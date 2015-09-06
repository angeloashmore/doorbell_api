defmodule DoorbellApi.Repo.Migrations.CreatePlan do
  use Ecto.Migration

  def change do
    create table(:plans) do
      add :name, :string
      add :type, :string

      timestamps
    end

  end
end
