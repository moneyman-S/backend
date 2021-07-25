defmodule Moneyman.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :username, :string
      add :email, :string
      add :password_hash, :string
      add :accepted_terms, :boolean, default: false, null: false

      timestamps()
    end

  end
end
