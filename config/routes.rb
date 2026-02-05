Rails.application.routes.draw do
  devise_for :users
  
  # Página inicial
  root 'home#index'
  
  # Dashboard
  get 'dashboard', to: 'dashboard#index'
  
  # Preferências
  resource :preferences, only: [:edit, :update]
  
  # Recomendações
  resources :recommendations, except: [:new, :create, :edit, :update] do
    member do
      patch :mark_watched
    end
  end
  
  # Rota especial para gerar recomendações (FORA do resources)
  post 'recommendations/generate', to: 'recommendations#generate', as: 'generate_recommendations'

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end