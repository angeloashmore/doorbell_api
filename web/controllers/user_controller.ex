defmodule DoorbellApi.UserController do
  use DoorbellApi.Web, :controller

  alias DoorbellApi.User

  plug :load_and_authorize_resource, model: User
  plug DoorbellApi.Plugs.Unauthorized

  def index(%{assigns: %{users: users}} = conn, _params) do
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> render("show.json", user: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(DoorbellApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(%{assigns: %{user: user}} = conn, %{"id" => id}) do
    render conn, "show.json", user: user
  end

  def update(%{assigns: %{user: user}} = conn, %{"id" => id, "user" => user_params}) do
    changeset = User.changeset(user, user_params)

    case Repo.update(changeset) do
      {:ok, user} ->
        render(conn, "show.json", user: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(DoorbellApi.ChangesetView, "error.json", changeset: changeset)
    end
  end
end
