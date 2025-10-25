Rails.application.routes.draw do
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "sessions#new"

  # Registration routes
  get 'signup', to: 'users#new'
  resources :users, only: [:create]

  # Login/Logout routes
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  # User reservations routes
  resources :reservations, only: [:index, :new, :create, :destroy]
  get 'reservations/slot', to: 'reservations#show_slot', as: :reservation_slot

  # Admin namespace
  namespace :admin do
    # Admin dashboard is the root
    root 'dashboard#show'
    
    # Admin resources
    resources :time_slots
    resources :reservations, only: [:index, :update, :destroy]
  end
end