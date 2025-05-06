Rails.application.routes.draw do
  resources :forecasts, only: [:index, :create]

  get '/about', to: 'forecasts#about'
  get "up" => "rails/health#show", as: :rails_health_check
  root 'forecasts#index'
end
