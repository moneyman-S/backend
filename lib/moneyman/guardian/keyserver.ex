defmodule Moneyman.Guardian.KeyServer do
  @moduledoc ~S"""
  A simple GenServer implementation of a custom `Guardian.Token.Jwt.SecretFetcher`
  This is appropriate for development but should not be used in production
  due to questionable private key storage, lack of multi-node support,
  node restart durability, and public key garbage collection.
  """

  use GenServer

  @behaviour Guardian.Token.Jwt.SecretFetcher

  @impl Guardian.Token.Jwt.SecretFetcher
  # This will always return a valid key as a new one will be generated
  # if it does not already exist.
  def fetch_signing_secret(_mod, _opts),
    do: {:ok, GenServer.call(__MODULE__, :fetch_private_key)}

  @impl Guardian.Token.Jwt.SecretFetcher
  # This assumes that the adapter properly assigned a key id (kid)
  # to the signing key. Make sure it's there! with something like
  # JOSE.JWK.merge(jwk, %{"kid" => JOSE.JWK.thumbprint(jwk)})
  # see https://tools.ietf.org/html/rfc7515#section-4.1.4
  # for details
  def fetch_verifying_secret(_mod, %{"kid" => kid}, _opts) do
    case GenServer.call(__MODULE__, {:fetch_public_key, kid}) do
      {:ok, public_key} -> {:ok, public_key}
      :error -> {:error, :secret_not_found}
    end
  end

  def fetch_verifying_secret(_, _, _), do: {:error, :secret_not_found}

  # This is not a defined callback for the SecretFetcher, but could be useful
  # for providing an endpoint that external services could use to verify tokens
  # for themselves.
  def fetch_verifying_secrets,
    do: GenServer.call(__MODULE__, :fetch_public_keys)

  # Expire the private key so that a new one will be generated on the next
  # signing request. The public key associated with the old private key should
  # be stored at the very least as long as the largest possible "exp"
  # (https://tools.ietf.org/html/rfc7519#section-4.1.4) value for any token
  # signed by the old private key before this method was called.
  def expire_private_key,
    do: GenServer.cast(__MODULE__, :expire_private_key)

  # Generate a new keypair along with the key ID (kid)
  @spec generate_keypair() :: {:ok, JOSE.JWK.t(), JOSE.JWK.t(), String.t()}
  def generate_keypair() do
    # Choose an appropriate signing algorithm for your security needs.
    private_key = JOSE.JWK.generate_key({:okp, :Ed25519})

    # Generate a kid by using the key's thumbprint
    # https://tools.ietf.org/html/draft-ietf-jose-jwk-thumbprint-08#section-1
    kid = JOSE.JWK.thumbprint(private_key)

    # Update the private key to contain the "kid"
    private_key = JOSE.JWK.merge(private_key, %{"kid" => kid})

    # Create a public key based on the private key. It will carry the same "kid"
    public_key = JOSE.JWK.to_public(private_key)

    {:ok, private_key, public_key, kid}
  end

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(_opts) do
    {:ok, %{private_key: nil, public_keys: %{}}}
  end

  # Callbacks

  def handle_cast(:expire_private_key, state),
    do: {:noreply, %{state | private_key: nil}}

  # Generate a new signing key if one does not already exist
  def handle_call(:fetch_private_key, _from, %{private_key: nil, public_keys: key_list}) do
    {:ok, private_key, public_key, kid} = generate_keypair()

    {:reply, private_key,
     %{
       private_key: private_key,
       public_keys: Map.put(key_list, kid, public_key)
     }}
  end

  def handle_call(:fetch_private_key, _from, %{private_key: private_key} = state),
    do: {:reply, private_key, state}

  def handle_call({:fetch_public_key, kid}, _from, %{public_keys: public_keys} = state),
    do: {:reply, Map.fetch(public_keys, kid), state}

  def handle_call(:fetch_public_keys, _from, %{public_keys: public_keys} = state),
    do: {:reply, Map.values(public_keys), state}
end