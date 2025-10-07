Rails.application.routes.draw do
  # Pages principales
  root "home#index"
  get "a-propos", to: "pages#about", as: :about

  # Recherche
  get "recherche", to: "search#index", as: :search

  # Librairies (bookshops)
  resources :bookshops, path: "librairies" do
    member do
      post :follow, path: "suivre"
      delete :unfollow, path: "ne-plus-suivre"
    end

    collection do
      get :map, path: "autour-de-moi"
    end
  end

  # Maisons d’édition (publishing_houses)
  resources :publishing_houses, path: "maisons-dedition"

  # Chroniques
  resources :chronicles, path: "chroniques" do
    resources :comments, only: [:create, :destroy], path: "commentaires"
    resource :like, only: [:create, :destroy], path: "aimer"
  end

  # Commentaires
  resources :comments, path: "commentaires", only: [] do
    patch :report, on: :member, path: "signaler"
  end

  resources :comments, path: "commentaires" do
    resources :comment_likes, only: [:create, :destroy], path: "likes"
  end

  # Notifications
  resources :notifications, only: [:index], path: "notifications" do
    collection do
      patch :mark_as_read, path: "marquer-comme-lues"
    end
  end

  # Suivi entre utilisateurs
  resources :follows, only: [:create, :destroy], path: "abonnements"

  # Conversations & Messages
  resources :conversations, only: [:index, :show, :create], path: "conversations" do
    resources :messages, only: [:create], path: "messages"
  end

  # Profils utilisateurs
  resources :users, only: [:show, :edit, :update], path: "utilisateurs"

  # Devise (authentification)
  devise_for :users, path: "", path_names: {
    sign_in: "connexion",
    sign_out: "deconnexion",
    sign_up: "inscription"
  }, controllers: {
    registrations: "users/registrations"
  }

  # Gestion des erreurs
  get "erreur/404", to: "errors#not_found", as: :not_found
  get "erreur/500", to: "errors#internal_server_error", as: :internal_server_error
  match "/404", to: "errors#not_found", via: :all
  match "/500", to: "errors#internal_server_error", via: :all

  # Santé de l'application (Heroku / Rails)
  get "up", to: "rails/health#show", as: :rails_health_check
  get "service-worker", to: "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest", to: "rails/pwa#manifest", as: :pwa_manifest
end

