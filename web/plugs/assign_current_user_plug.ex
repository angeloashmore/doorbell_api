defmodule DoorbellApi.Plugs.AssignCurrentUser do
  import Plug.Conn, only: [assign: 3]

  alias DoorbellApi.Repo
  alias DoorbellApi.User

  @doc """
  Load the user model using the JWT `sub` claim set by Joken.
  """
  @spec assign_current_user(Plug.Conn.t, map) :: Plug.Conn.t
  def assign_current_user(%Plug.Conn{assigns: %{joken_claims: %{sub: remote_user_id}}} = conn, _opts) do
    user = Repo.get_by(User, remote_id: remote_user_id)
    conn |> assign :current_user, user
  end
  def assign_current_user(conn, _opts), do: conn
end
