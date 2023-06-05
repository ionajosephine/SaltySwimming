Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root to: "stations#index"
  get "/about", to: "pages#about"
  get "/behind-the-scenes", to: "pages#innovation"
  get "/the-why-of-salty-swimming", to: "pages#why"
  get "/what-affects-tidal-variation", to: "pages#tidal_variation"
  get "/faqs", to: "pages#faqs"

  resources :stations, only: [:index, :show]
  resources :spots
end
