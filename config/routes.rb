Rails.application.routes.draw do

  root "home#index"

  namespace :slack do
    post "event"
  end

  get "/login"                   , to: "sessions#new"     , as: :login
  get "/logout"                  , to: "sessions#destroy" , as: :logout
  get "/auth/failure"            , to: "sessions#failure"
  get "/auth/:provider/setup"    , to: "sessions#setup"
  get "/auth/:provider/callback" , to: "sessions#create"

  resources "membership_submissions", only: [:new, :create],
    path: "join-now", path_names: { new: "" }

  get "/admin", to: "admin/dashboard#index", as: :admin

  namespace :admin do
    resources "users", only: [:index]
    resources "channels", only: [:index]

    resources "membership_submissions" do
      collection do
        get "pending"
      end
      member do
        get "approve"
        get "reject"
      end
    end
  end
end
