defmodule DoorbellApi.Plugs.Unauthorized do
  import Plug.Conn

  def init(default), do: default

  def call(%Plug.Conn{assigns: %{authorized: authorized}} = conn, _)
    when authorized == true, do: conn
  def call(conn, _) do
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
