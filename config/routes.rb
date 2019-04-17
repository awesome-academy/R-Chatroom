Rails.application.routes.draw do
  post "rooms/join", format: "json"
  post "rooms/leave", format: "json"

  resources :users, only: [:index, :show, :create], format: "json" do
    get "activate/:token", to: "account_activations#activate", format: "json"
    resources :rooms, only: [:index], format: "json"
  end

  resources :rooms, format: "json" do
    resources :users, only: [:index, :destroy], format: "json"
  end

  resources :sessions, only: [:create, :destroy], format: "json"

  resource :user, only: [:show], format: "json"

  root "pages#index"

  mount ActionCable.server => "/cable"
end
