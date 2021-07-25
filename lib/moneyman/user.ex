defmodule Moneyman.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :accepted_terms, :boolean, default: false
    field :email, :string
    field :name, :string
    field :password_hash, :string
    field :username, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :username, :email, :password_hash, :accepted_terms])
    |> validate_required([:name, :username, :email, :password_hash, :accepted_terms])
    |> unique_constraint([:email, :username])
  end
end