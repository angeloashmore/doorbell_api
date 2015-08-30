defmodule DoorbellApi.UserView do
  use DoorbellApi.Web, :view

  def render("index.json", %{users: users}) do
    %{data: render_many(users, DoorbellApi.UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, DoorbellApi.UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      remote_id: user.remote_id,
      email: user.email,
      name: user.name}
  end
end
