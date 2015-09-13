defmodule DoorbellApi.Router do
  use DoorbellApi.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authorization do
    plug Joken.Plug, on_verifying: &JokenPlugConfig.on_verifying/0, on_error: &JokenPlugConfig.on_error/2
    plug :assign_current_user
  end

  pipeline :auth0_authorization do
    plug Joken.Plug, on_verifying: &JokenPlugConfig.Auth0.on_verifying/0, on_error: &JokenPlugConfig.Auth0.on_error/2
    plug :assign_current_user
  end

  scope "/", DoorbellApi do
    pipe_through :api
    pipe_through :authorization

    resources "/billings", BillingController, only: [:show, :update]
    resources "/plans", PlanController, only: [:index, :show]
    post "/teams/search", TeamController, :search
    resources "/teams", TeamController, except: [:new]
    resources "/team_users", TeamUserController, except: [:index, :new]
    resources "/users", UserController, only: [:show, :update]
    resources "/chats", ChatController, except: [:new]
  end

  scope "/", DoorbellApi do
    pipe_through :api
    pipe_through :auth0_authorization

    post "/users", UserController, :create
  end
end
