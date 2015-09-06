defmodule DoorbellApi.JokenPlugConfig do
  import Joken

  def on_verifying do
    signer = Application.get_env(:auth0, :client_secret)
    |> :base64url.decode
    |> hs256

    token(%{})
    |> with_validation(:aud, &(&1 == Application.get_env(:auth0, :client_id)))
    |> with_signer(signer)
  end

  def on_error(conn, message) do
    { conn, %{error: message} }
  end
end

defmodule DoorbellApi.JokenPlugConfig.Auth0 do
  import Joken

  def on_verifying do
    signer = Application.get_env(:auth0, :doorbell_client_secret)
    |> :base64url.decode
    |> hs256

    token(%{})
    |> with_validation(:aud, &(&1 == Application.get_env(:auth0, :doorbell_client_id)))
    |> with_signer(signer)
  end

  def on_error(conn, message) do
    { conn, %{error: message} }
  end
end
