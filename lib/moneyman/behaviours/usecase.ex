defmodule Moneyman.Usecase do
  @callback execute(map()) ::
    {:ok, term()}
    | {:error, String.t()}
    | {:error, Atom.t()}
end
