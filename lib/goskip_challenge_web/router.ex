defmodule GoskipChallengeWeb.Router do
  use GoskipChallengeWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/v1", GoskipChallengeWeb.API.V1, as: :api_v1 do
    pipe_through :api

    get "/temperature", TemperatureController, :index
  end

  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: GoskipChallengeWeb.Telemetry
    end
  end

  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
