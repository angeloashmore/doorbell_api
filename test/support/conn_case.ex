defmodule DoorbellApi.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  imports other functionality to make it easier
  to build and query models.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest

      alias DoorbellApi.Repo
      import Ecto.Model
      import Ecto.Query, only: [from: 2]
      import Joken

      import DoorbellApi.Router.Helpers

      # The default endpoint for testing
      @endpoint DoorbellApi.Endpoint

      # The default valid JWT for testing
      @valid_jwt token
      |> with_sub("remote_1")
      |> with_aud(Application.get_env(:auth0, :client_id))
      |> with_signer(hs256(:base64url.decode(Application.get_env(:auth0, :client_secret))))
      |> sign
      |> get_compact

      # The default valid Auth0 JWT for testing
      @valid_auth0_jwt token
      |> with_sub("remote_1")
      |> with_aud(Application.get_env(:auth0, :doorbell_client_id))
      |> with_signer(hs256(:base64url.decode(Application.get_env(:auth0, :doorbell_client_secret))))
      |> sign
      |> get_compact
    end
  end

  setup tags do
    unless tags[:async] do
      Ecto.Adapters.SQL.restart_test_transaction(DoorbellApi.Repo, [])
    end

    :ok
  end
end
