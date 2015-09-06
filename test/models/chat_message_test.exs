defmodule DoorbellApi.ChatMessageTest do
  use DoorbellApi.ModelCase

  alias DoorbellApi.Chat

  @valid_attrs %{body: "My chat message"}
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
