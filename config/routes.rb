Rails.application.routes.draw do
  # Health Check
  get "up" => "rails/health#show", as: :rails_health_check

  #API routes
  namespace :api do
    namespace :v1 do
      resources :conversions, only: [:create]
      resources :transactions, only: [:index]
    end
  end
end
