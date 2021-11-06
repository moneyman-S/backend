defmodule Moneyman.Register do
	alias Moneyman.Register.Usecases.SignUp,
		as: SignUpUsecase

	alias Moneyman.Register.Usecases.SendVerificationEmail,
		as: SendVerificationEmailUsecase

	defdelegate sign_up(args),
		to: SignUpUsecase,
		as: :execute

	defdelegate send_verification_email(args),
		to: SendVerificationEmailUsecase,
		as: :execute
end
