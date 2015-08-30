defmodule DoorbellApi.Router do
  use DoorbellApi.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", DoorbellApi do
    pipe_through :api

    resources "/billings", BillingController
    resources "/plans", PlanController
    resources "/teams", TeamController
    resources "/team_members", TeamMemberController
    resources "/users", UserController
  end
end
