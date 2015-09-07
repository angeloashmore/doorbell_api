defmodule DoorbellApi.ChatController do
  use DoorbellApi.Web, :controller

  alias DoorbellApi.Chat

  plug :authorize_resource, model: Chat
  plug :load_resource, model: Chat, except: :index, preload: :chat_participants
  plug :halt_unauthorized_user

  def index(conn, _params) do
    query = from c in Chat,
      join: cp in assoc(c, :chat_participants),
      where: cp.gen_user_id == ^conn.assigns.current_user.gen_user.id,
      select: c,
      preload: :chat_participants
    chats = Repo.all(query)
    render(conn, "index.json", chats: chats)
  end

  def create(conn, %{"chat" => chat_params}) do
    changeset = Chat.changeset(%Chat{}, chat_params)

    case Repo.insert(changeset) do
      {:ok, chat} ->
        chat = Repo.preload(chat, :chat_participants)

        conn
        |> put_status(:created)
        |> render("show.json", chat: chat)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(DoorbellApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(%{assigns: %{chat: chat}} = conn, _params) do
    render conn, "show.json", chat: chat
  end

  def update(%{assigns: %{chat: chat}} = conn, %{"chat" => chat_params}) do
    changeset = Chat.changeset(chat, chat_params)

    case Repo.update(changeset) do
      {:ok, chat} ->
        render(conn, "show.json", chat: chat)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(DoorbellApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(%{assigns: %{chat: chat}} = conn, _params) do
    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(chat)

    send_resp(conn, :no_content, "")
  end
end
