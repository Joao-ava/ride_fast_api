defmodule RideFast.Guardian do
  use Guardian, otp_app: :ride_fast

  alias RideFast.Accounts

  def subject_for_token(%{role: role, id: id}, _claims) do
    sub = "#{role}_#{id}"
    {:ok, sub}
  end

  def resource_from_claims(%{"sub" => sub}) do
    # Here we'll look up our resource from the claims, the subject can be
    # found in the `"sub"` key. In above `subject_for_token/2` we returned
    # the resource id so here we'll rely on that to look it up.
    [role, id] = String.split(sub, "_")
    resource = Accounts.get_account(role, id)
    {:ok,  resource}
  end
  def resource_from_claims(_claims) do
    {:error, :reason_for_error}
  end
end
