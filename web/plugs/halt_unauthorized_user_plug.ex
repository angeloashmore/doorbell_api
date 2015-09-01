defmodule DoorbellApi.Plugs.HaltUnauthorizedUser do
  import Plug.Conn, only: [assign: 3, put_resp_content_type: 2, send_resp: 3, halt: 1]
  import Keyword, only: [has_key?: 2]

  @doc """
  Halts the conn if the user is unauthorized. Checks `conn.assigns.authorized`
  (boolean) set by Canary.

  Optional opts:
  * `:only` - Specifies which actions to authorize
  * `:except` - Specifies which actions for which to skip authorization

  Examples:
  ```
  plug :halt_unauthorized_user

  plug :halt_unauthorized_user, only: [:index, :show]

  plug :halt_unauthorized_user, except: :index
  ```
  """
  @spec halt_unauthorized_user(Plug.Conn.t, map) :: Plug.Conn.t
  def halt_unauthorized_user(conn, opts) do
    conn
    |> action_valid?(opts)
    |> case do
      true  -> _halt_unauthorized_user(conn, opts)
      false -> conn
    end
  end

  @spec _halt_unauthorized_user(Plug.Conn.t, map) :: Plug.Conn.t
  defp _halt_unauthorized_user(%Plug.Conn{assigns: %{authorized: authorized}} = conn, _)
    when authorized == true, do: conn
  defp _halt_unauthorized_user(conn, _) do
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

  @spec get_action(Plug.Conn.t) :: atom
  defp get_action(conn) do
    conn.assigns
    |> Map.fetch(:action)
    |> case do
      {:ok, action} -> action
      _             -> conn.private.phoenix_action
    end
  end

  @spec action_exempt?(Plug.Conn.t, map) :: boolean
  defp action_exempt?(conn, opts) do
    action = get_action(conn)

    (is_list(opts[:except]) && action in opts[:except])
    |> case do
      true  -> true
      false -> action == opts[:except]
    end
  end

  @spec action_included?(Plug.Conn.t, map) :: boolean
  defp action_included?(conn, opts) do
    action = get_action(conn)

    (is_list(opts[:only]) && action in opts[:only])
    |> case do
      true  -> true
      false -> action == opts[:only]
    end
  end

  @spec action_valid?(Plug.Conn.t, map) :: boolean
  defp action_valid?(conn, opts) do
    cond do
      has_key?(opts, :except) && has_key?(opts, :only) ->
        false
      has_key?(opts, :except) ->
        !action_exempt?(conn, opts)
      has_key?(opts, :only) ->
        action_included?(conn, opts)
      true ->
        true
    end
  end
end
