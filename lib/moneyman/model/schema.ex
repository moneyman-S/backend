defmodule Moneyman.Model.Schema do
  defmacro __using__(_opts) do
    quote do
      use Ecto.Schema
      import Ecto.Changeset

      @primary_key {:uuid, :binary_id, autogenerate: true}
      @foreign_key_type :binary_id
    end
  end
end
