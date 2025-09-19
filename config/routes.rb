Rails.application.routes.draw do
  get "search", to: "search#index"
  get "errors/not_found"
  get "errors/internal_server_error"
  get "pages/about"
  get "messages/create"
  get "conversations/index"
  get "conversations/show"
  get "conversations/create"
  resources :publishing_houses
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
  resources :users, only: [:show, :edit, :update]

  # Chroniques
  resources :chronicles do
    resources :comments, only: [:create, :destroy]
    resource :like, only: [:create, :destroy]
  end

  # Commentaires
  resources :comments, only: [] do
    patch :report, on: :member
  end

  resources :comments do
      resources :comment_likes, only: [:create, :destroy]
  end

  # Notifications
  resources :notifications, only: [:index] do
    collection do
      patch :mark_as_read
    end
  end

  # Gestion des erreurs
  match "/404", to: "errors#not_found", via: :all
  match "/500", to: "errors#internal_server_error", via: :all

  # Suivi entre utilisateurs
  resources :publishing_houses
  resources :follows, only: [:create, :destroy]

  resources :conversations, only: [:index, :show, :create] do
    resources :messages, only: [:create]
  end
  get "about", to: "pages#about"
  get "bookshops", to: "pages#bookshops"
end
