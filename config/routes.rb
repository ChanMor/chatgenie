Rails.application.routes.draw do
  get "reservations/index"
  get "reservations/new"
  get "reservations/create"
  get "reservations/destroy"
  root "sessions#new"

  get "sessions/new"
  get "sessions/create"
  get "sessions/destroy"
  get "users/new"
  get "users/create"
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  # Registration routes
  get 'signup', to: 'users#new'
  resources :users, only: [:create]

  # Login/Logout routes
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  resources :reservations, only: [:index, :new, :create, :destroy]

  namespace :admin do
    get "dashboard/show"
    get "reservations/index"
    get "tables/index"
    get "tables/new"
    get "tables/create"
    get "tables/edit"
    get "tables/update"
    get "tables/destroy"
    # Directs /admin to the tables index page
    root 'dashboard#show'
    resources :tables
    resources :reservations, only: [:index]
  end
end