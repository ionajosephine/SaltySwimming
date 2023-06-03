Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root to: "stations#index"
  get "/about", to: "pages#about"
  get "/innovation", to: "pages#innovation"

  resources :stations, only: [:index, :show]
  resources :spots
end
