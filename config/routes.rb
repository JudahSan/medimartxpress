Rails.application.routes.draw do
  get 'about/index'
  namespace :admin do
    resources :orders
    resources :products do
      resources :stocks
    end
    resources :categories
  end
  devise_for :admins
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "home#index"

  # About page
  get '/about', to: 'about#index'

  authenticated :admin_users do
    root to: "admin#index", as: :admin_root
  end

  # setup admin index route
  get "admin" => "admin#index"

  # dark-light mode
  get "set_theme", to: "theme#index"

  get "category" => "category#index"
end
