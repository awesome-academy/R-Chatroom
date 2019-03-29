Rails.application.routes.draw do
  resources :users, only: [:index, :show, :create]
  resources :sessions, only: [:create, :destroy]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
