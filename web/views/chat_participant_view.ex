defmodule DoorbellApi.ChatParticipantView do
  use DoorbellApi.Web, :view

  def render("index.json", %{chat_participants: chat_participants}) do
    %{data: render_many(chat_participants, DoorbellApi.ChatParticipantView, "chat_participant.json")}
  end

  def render("show.json", %{chat_participant: chat_participant}) do
    %{data: render_one(chat_participant, DoorbellApi.ChatParticipantView, "chat_participant.json")}
  end

  def render("chat_participant.json", %{chat_participant: chat_participant}) do
    %{id: chat_participant.id,
      chat_id: chat_participant.chat_id,
      gen_user_id: chat_participant.gen_user_id}
  end
end
