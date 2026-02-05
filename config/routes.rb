Rails.application.routes.draw do
  devise_for :users
  
  # Página inicial
  root 'home#index'
  
  # Dashboard
  get 'dashboard', to: 'dashboard#index'
  
  # Preferências
  resource :preferences, only: [:edit, :update]
  
  # Recomendações
  resources :recommendations do
    member do
      patch :mark_watched
    end
    collection do
      post :generate
    end
  end

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end