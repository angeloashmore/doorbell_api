defmodule DoorbellApi.Plugs.CurrentUser do
  import Plug.Conn

  alias DoorbellApi.Repo
  alias DoorbellApi.User

  def init(default \\ nil), do: default

  def call(%Plug.Conn{assigns: %{joken_claims: %{user_id: user_id}}} = conn, _default) do
    user = Repo.get(User, user_id)
    assign(conn, :current_user, user)
  end
  def call(conn, default), do: assign(conn, :current_user, default)
end
