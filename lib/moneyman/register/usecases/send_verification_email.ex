defmodule Moneyman.Register.Usecases.SendVerificationEmail do
  @behaviour Moneyman.Usecase
  import Swoosh.Email
  use Phoenix.Swoosh, view: :xpto, layout: {:view, :email}
  alias Moneyman.Register.Model.User

  @subject "Activation Email"
  @from {"Moneyman", "noreply@moneyman.com"}
  @template_file "verification_email.html"

  @type args :: %{

  }

  @impl Moneyman.Usecase
  @spec execute(args) ::
    {:ok, User.t()}
    | {:error, :bad_input}
  def execute(_args) do
    user = %User{
      name: "",
      username: "",
      email: "",
      password_hash: ""
    }

    {:ok, user}
  end

  def generate_email(%User{} = user, token) do
    new()
    |> to({user.name, user.email})
    |> from(@from)
    |> subject(@subject)
    |> render_body(@template_file, %{token: token})
  end
end
