defmodule DoorbellApi.ChatView do
  use DoorbellApi.Web, :view

  alias DoorbellApi.ChatParticipantView

  def render("index.json", %{chats: chats}) do
    %{data: render_many(chats, DoorbellApi.ChatView, "chat.json")}
  end

  def render("show.json", %{chat: chat}) do
    %{data: render_one(chat, DoorbellApi.ChatView, "chat.json")}
  end

  def render("chat.json", %{chat: chat}) do
    chat_participants = chat.chat_participants
    |> Enum.map &(ChatParticipantView.render("chat_participant.json", %{chat_participant: &1}))

    %{id: chat.id,
      place_id: chat.place_id,
      chat_participants: chat_participants}
  end
end
