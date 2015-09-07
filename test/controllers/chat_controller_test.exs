defmodule DoorbellApi.ChatControllerTest do
  use DoorbellApi.ConnCase

  alias DoorbellApi.Chat
  alias DoorbellApi.ChatParticipant
  @valid_attrs %{gen_user_id: 1, place_id: "place_1"}
  @invalid_attrs %{}

  setup do
    conn = conn()
    |> put_req_header("accept", "application/json")
    |> put_req_header("authorization", "Bearer " <> @valid_jwt)
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, chat_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "does not list all entries and instead responds with unauthorized when authorization header is nonexistent", %{conn: conn} do
    conn = delete_req_header(conn, "authorization")
    conn = get conn, chat_path(conn, :index)
    assert json_response(conn, 401)["error"] == "Unauthorized"
  end

  test "shows chosen resource", %{conn: conn} do
    chat = Repo.insert! %Chat{}
    chat_participant = Repo.insert!(%ChatParticipant{chat_id: chat.id, gen_user_id: 1})
    conn = get conn, chat_path(conn, :show, chat)
    assert json_response(conn, 200)["data"] == %{"id" => chat.id,
      "place_id" => chat.place_id,
      "chat_participants" => [%{
        "id" => chat_participant.id,
        "chat_id" => chat_participant.chat_id,
        "gen_user_id" => chat_participant.gen_user_id
      }]}
  end

  test "does not show resource and instead responds with unauthorized when id is nonexistent", %{conn: conn} do
    conn = get conn, chat_path(conn, :show, -1)
    assert json_response(conn, 401)["error"] == "Unauthorized"
  end

  test "does not show resource and instead responds with unauthorized when authorization header is nonexistent", %{conn: conn} do
    chat = Repo.insert! %Chat{}
    conn = delete_req_header(conn, "authorization")
    conn = get conn, chat_path(conn, :show, chat)
    assert json_response(conn, 401)["error"] == "Unauthorized"
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, chat_path(conn, :create), chat: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Chat, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, chat_path(conn, :create), chat: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "does not create resource and instead responds with unauthorized when authorization header is nonexistent", %{conn: conn} do
    conn = delete_req_header(conn, "authorization")
    conn = post conn, chat_path(conn, :create), chat: @valid_attrs
    assert json_response(conn, 401)["error"] == "Unauthorized"
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    chat = Repo.insert! %Chat{gen_user_id: 1}
    conn = put conn, chat_path(conn, :update, chat), chat: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Chat, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    chat = Repo.insert! %Chat{gen_user_id: 1}
    Repo.insert!(%ChatParticipant{chat_id: chat.id, gen_user_id: 1})
    conn = put conn, chat_path(conn, :update, chat), chat: @invalid_attrs
    assert json_response(conn, 422)["error"] != %{}
  end

  test "does not update chosen resource and instead responds with unauthorized when authorization header is nonexistent", %{conn: conn} do
    chat = Repo.insert! %Chat{gen_user_id: 1}
    conn = delete_req_header(conn, "authorization")
    conn = put conn, chat_path(conn, :update, chat), chat: @invalid_attrs
    assert json_response(conn, 401)["error"] == "Unauthorized"
  end

  test "deletes chosen resource", %{conn: conn} do
    chat = Repo.insert! %Chat{gen_user_id: 1}
    conn = delete conn, chat_path(conn, :delete, chat)
    assert response(conn, 204)
    refute Repo.get(Chat, chat.id)
  end

  test "does not delete chosen resource and instead responds with unauthorized when authorization header is nonexistent", %{conn: conn} do
    chat = Repo.insert! %Chat{gen_user_id: 1}
    conn = delete_req_header(conn, "authorization")
    conn = delete conn, chat_path(conn, :delete, chat)
    assert json_response(conn, 401)["error"] == "Unauthorized"
  end
end
