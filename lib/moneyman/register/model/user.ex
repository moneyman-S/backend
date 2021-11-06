defmodule Moneyman.Register.Model.User do
  use Moneyman.Model.Schema
  import Moneyman.Changeset
  alias Ecto.Changeset

  @type id :: String.t()
  @type idt :: id() | t()
  @type name :: String.t()
  @type username :: String.t()
  @type email :: String.t()
  @type password :: String.t()
  @type password_hash :: String.t()
  @type t :: %__MODULE__{
    name: name(),
    username: username(),
    email: email(),
    password_hash: password_hash()
  }
  @type create_or_update_params :: %{
    name: name(),
    username: username(),
    email: email(),
    password: password(),
    password_confirmation: password()
  }
  @type changeset :: %Changeset{data: %{__struct__: __MODULE__}}
  @type t_or_changeset :: t() | changeset()
  @typep creation_base :: %__MODULE__{} | t_or_changeset()

  @cast_fields ~w(name username email password password_confirmation)a
  @required_fields ~w(name username email password_hash)a

  schema "users" do
    field :email, :string
    field :name, :string
    field :username, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    timestamps()
  end

  @spec changeset(creation_base(), create_or_update_params) :: changeset()
  def changeset(user \\ %__MODULE__{}, attrs)
  def changeset(user, attrs) do
    user
    |> cast(attrs, @cast_fields)
    |> validate_required(@required_fields)
    |> validate_email(:email)
    |> validate_confirmation(:password)
    |> put_password_hash()
    |> unique_constraint([:email, :username])
  end
end
