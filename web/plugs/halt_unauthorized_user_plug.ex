defmodule DoorbellApi.Plugs.HaltUnauthorizedUser do
  import Plug.Conn, only: [assign: 3, put_resp_content_type: 2, send_resp: 3, halt: 1]

  @doc """
  Halts the conn if the user is unauthorized. Checks `conn.assigns.authorized`
  (boolean) set by Canary.
  """
  @spec halt_unauthorized_user(Plug.Conn.t, map) :: Plug.Conn.t
  def halt_unauthorized_user(%Plug.Conn{assigns: %{authorized: authorized}} = conn, _)
    when authorized == true, do: conn
  def halt_unauthorized_user(conn, _) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(401, error_message)
    |> halt
  end

  @spec error_message :: String.t
  defp error_message do
    %{error: "Unauthorized"}
    |> Poison.encode!
  end
end
