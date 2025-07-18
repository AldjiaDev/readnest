Rails.application.routes.draw do
  # Devise (authentification)
  devise_for :users, controllers: {
    registrations: "users/registrations"
  }

  # Page d'accueil
  root "home#index"

  # Pages statiques ou personnalisées
  get "up", to: "rails/health#show", as: :rails_health_check
  get "service-worker", to: "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest", to: "rails/pwa#manifest", as: :pwa_manifest

  # Profils utilisateurs
  resources :users, only: [:show]

  # Chroniques
  resources :chronicles do
    resources :comments, only: [:create, :destroy]
    resource :like, only: [:create, :destroy]
  end

  # Commentaires
  resources :comments, only: [] do
    patch :report, on: :member
  end

  # Notifications
  resources :notifications, only: [:index] do
    patch :mark_as_read, on: :member
  end

  # Suivi entre utilisateurs
  resources :follows, only: [:create, :destroy]
end
