Rails.application.routes.draw do
  get "homepage/index"

  get "up" => "rails/health#show", as: :rails_health_check

  root "homepage#index" # highlight-line
end