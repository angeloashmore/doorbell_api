defmodule DoorbellApi.ChatTest do
  use DoorbellApi.ModelCase

  alias DoorbellApi.Chat

  @valid_attrs %{place_id: "random_id", archived: false}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Chat.changeset(%Chat{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Chat.changeset(%Chat{}, @invalid_attrs)
    refute changeset.valid?
  end
end
