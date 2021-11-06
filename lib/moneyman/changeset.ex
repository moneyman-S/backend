defmodule Moneyman.Changeset do
  import Ecto.Changeset
  alias Ecto.Changeset
  alias Argon2

  @email_format ~r/(\w+)@([\w.]+)/i

  @spec put_password_hash(Changeset.t) :: Changeset.t()
  def put_password_hash(%Ecto.Changeset{valid?: false} = changeset),
    do: changeset
  def put_password_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset),
    do: change(changeset, password_hash: Argon2.hash_pwd_salt(password))
  def put_password_hash(changeset),
    do: changeset

  @spec validate_email(Changeset.t, atom()) :: Changeset.t
  def validate_email(changeset, field),
    do: validate_format(changeset, field, @email_format)
end
