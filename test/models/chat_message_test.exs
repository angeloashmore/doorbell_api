defmodule DoorbellApi.ChatMessageTest do
  use DoorbellApi.ModelCase

  alias DoorbellApi.ChatMessage

  @valid_attrs %{chat_id: "1", gen_user_id: "1", body: "My chat message"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = ChatMessage.changeset(%ChatMessage{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = ChatMessage.changeset(%ChatMessage{}, @invalid_attrs)
    refute changeset.valid?
  end
end
