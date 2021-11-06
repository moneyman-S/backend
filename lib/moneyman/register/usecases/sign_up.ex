defmodule Moneyman.Register.Usecases.SignUp do
  @behaviour Moneyman.Usecase

  alias Ecto.Changeset
  alias Moneyman.Register.Model.User
  alias Moneyman.Repo

  @parameters ~w[
    name
    email
    username
    password
    password_confirmation
  ]a

  @type args :: %{
    name: User.name(),
    email: User.email(),
    username: User.username(),
    password: User.password(),
    password_confirmation: User.password()
  }

  @impl Moneyman.Usecase
  @spec execute(args) ::
    {:ok, User.t()}
    | {:error, :bad_input}
  def execute(args) do
    {args, _} = Map.split(args, @parameters)

    args
    |> User.changeset
    |> Repo.insert()
    |> case do
      {:ok, %User{} = user} ->
        {:ok, user}
      {:error, %Changeset{} = changeset} ->
        {:error, changeset}
    end
  end
end
