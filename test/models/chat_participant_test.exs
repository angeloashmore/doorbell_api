defmodule DoorbellApi.ChatParticipantTest do
  use DoorbellApi.ModelCase

  alias DoorbellApi.ChatParticipant

  @valid_attrs %{chat_id: 1, gen_user_id: 1}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = ChatParticipant.changeset(%ChatParticipant{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = ChatParticipant.changeset(%ChatParticipant{}, @invalid_attrs)
    refute changeset.valid?
  end
end
