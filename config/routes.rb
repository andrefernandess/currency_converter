Rails.application.routes.draw do
  # Health check para Render
  get '/health', to: proc { [200, {}, ['OK']] }

  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  
  # API routes
  namespace :api do
    namespace :v1 do
      post "convert", to: "conversions#create"
      resources :transactions, only: [:index]
    end
  end
end
