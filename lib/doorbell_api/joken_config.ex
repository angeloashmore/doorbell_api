defmodule DoorbellApi.JokenConfig do
  import Joken

  def on_verifying do
    token(%{})
    |> with_validation(:aud, &(&1 == Application.get_env(:auth0, :client_id)))
    |> with_signer(hs256(Application.get_env(:auth0, :client_secret)))
  end

  def on_error(conn, message) do
    { conn, %{error: message} }
  end
end
