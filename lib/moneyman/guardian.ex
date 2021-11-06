defmodule Moneyman.Guardian do
	use Guardian, otp_app: :moneyman

	def subject_for_token(_resource, _claims) do
    #sub = to_string(resource.id)
    {:ok, ""} #sub}
  end

  #def subject_for_token(_, _),
  #  do: {:error, :reason_for_error}

  def resource_from_claims(_claims) do
    #id = claims["sub"]
    #resource = Moneyman.get_resource_by_id(id)
    {:ok, ""} #resource}
  end

  #def resource_from_claims(_claims),
  #  do: {:error, :reason_for_error}
end
