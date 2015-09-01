defmodule DoorbellApi.Router do
  use DoorbellApi.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug Joken.Plug, on_verifying: &JokenPlugConfig.on_verifying/0, on_error: &JokenPlugConfig.on_error/2
    plug :assign_current_user
  end

  pipeline :api_auth0 do
    plug :accepts, ["json"]
    plug Joken.Plug, on_verifying: &JokenPlugConfig.Auth0.on_verifying/0, on_error: &JokenPlugConfig.Auth0.on_error/2
    plug :assign_current_user
  end

  scope "/", DoorbellApi do
    pipe_through :api

    resources "/billings", BillingController, only: [:show, :update]
    resources "/plans", PlanController, only: [:index, :show]
    resources "/teams", TeamController, except: [:new]
    resources "/team_members", TeamMemberController, except: [:index, :new]
    resources "/users", UserController, only: [:show, :update]
  end

  scope "/", DoorbellApi do
    pipe_through :api_auth0

    post "/users", UserController, :create
  end
end
