defmodule Moneyman.Accounts do
	alias Moneyman.Repo
	alias Moneyman.Accounts.User

	@spec register_user(User.creation_params) :: {:ok, User.t()} | {:error, String.t()}
	def register_user(params) do
		User
		|> User.changeset(params)
		|> Repo.insert()
	end

	@spec activate_user(String.t()) ::
		{:ok, User.t()}
		| {:error, String.t()}
	def activate_user() do
	end

	@spec update_profile(String.t(), User.update_params) ::
		{ :ok, User.t() }
		| { :error, String.t() }
	def update_profile(id, params) do
		User
		|> Repo.get!(id)
		|> User.changeset(params)
		|> Repo.update()
	end
end