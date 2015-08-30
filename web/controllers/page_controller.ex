defmodule DoorbellApi.PageController do
  use DoorbellApi.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
