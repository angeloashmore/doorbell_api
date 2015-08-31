defmodule DoorbellApi.Web do
  @moduledoc """
  A module that keeps using definitions for controllers,
  views and so on.

  This can be used in your application as:

      use DoorbellApi.Web, :controller
      use DoorbellApi.Web, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below.
  """

  def model do
    quote do
      use Ecto.Model
    end
  end

  def controller do
    quote do
      use Phoenix.Controller

      alias DoorbellApi.Repo
      import Ecto.Model
      import Ecto.Query, only: [from: 1, from: 2]

      import DoorbellApi.Router.Helpers
    end
  end

  def view do
    quote do
      use Phoenix.View, root: "web/templates"

      import DoorbellApi.Router.Helpers
    end
  end

  def router do
    quote do
      use Phoenix.Router

      alias DoorbellApi.JokenConfig
    end
  end

  def channel do
    quote do
      use Phoenix.Channel

      alias DoorbellApi.Repo
      import Ecto.Model
      import Ecto.Query, only: [from: 1, from: 2]
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
