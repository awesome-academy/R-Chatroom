Rails.application.routes.draw do
  post "rooms/join"

  resources :users, only: [:index, :show, :create], format: "json" do
    resources :rooms, only: [:index], format: "json"
  end

  resources :rooms, format: "json"
  resources :sessions, only: [:create, :destroy], format: "json"

  resource :user, only: [:show], format: "json"

  root "pages#index"

  mount ActionCable.server => "/cable"
end
