defmodule DoorbellApi.Router do
  use DoorbellApi.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug Joken.Plug, on_verifying: &JokenPlugConfig.on_verifying/0, on_error: &JokenPlugConfig.on_error/2
    plug DoorbellApi.Plugs.CurrentUser
  end

  scope "/", DoorbellApi do
    pipe_through :api

    resources "/billings", BillingController, except: [:new, :delete]
    resources "/plans", PlanController, only: [:index, :show]
    resources "/teams", TeamController, except: [:new]
    resources "/team_members", TeamMemberController, except: [:new]
    resources "/users", UserController, except: [:new, :delete]
  end
end
