Rails.application.routes.draw do
  get "favorites/create"
  get "favorites/destroy"
  get "favorites/index"
  get "authors/index"
  get "authors/show"
  # Pages principales
  root "home#index"
  get "a-propos",                  to: "pages#about",           as: :about
  get "mentions-legales",          to: "pages#mentions_legales", as: :mentions_legales
  get "politique-de-confidentialite", to: "pages#confidentialite", as: :confidentialite
  get "conditions-generales",      to: "pages#cgu",              as: :cgu
  get "politique-des-cookies",     to: "pages#cookies",          as: :cookies
  get "plan-du-site",              to: "pages#plan_du_site",     as: :plan_du_site

  # Pages éditoriales SEO — littérature & lecture
  get "comment-ecrire-une-chronique-litteraire", to: "pages#ecrire_chronique",      as: :ecrire_chronique
  get "soutenir-librairies-independantes",        to: "pages#soutenir_librairies",   as: :soutenir_librairies
  get "comment-choisir-son-prochain-livre",       to: "pages#choisir_livre",         as: :choisir_livre
  get "quest-ce-qu-une-chronique-litteraire",     to: "pages#definition_chronique",  as: :definition_chronique
  get "litterature-francaise-contemporaine",      to: "pages#litterature_francaise", as: :litterature_francaise
  get "maisons-edition-independantes-france",     to: "pages#editions_independantes",as: :editions_independantes
  get "communaute-de-lecteurs-en-ligne",          to: "pages#communaute_lecteurs",   as: :communaute_lecteurs
  get "bienfaits-de-la-lecture",                  to: "pages#bienfaits_lecture",     as: :bienfaits_lecture
  get "glossaire-litteraire",                     to: "pages#glossaire",             as: :glossaire
  get "librairies-independantes-paris",           to: "pages#librairies_paris",      as: :librairies_paris
  get "librairies-independantes-lyon",            to: "pages#librairies_lyon",       as: :librairies_lyon
  get "librairies-independantes-marseille",       to: "pages#librairies_marseille",  as: :librairies_marseille

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
  resources :chronicles, path: "chroniques", param: :slug do
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

  # Auteur·ice·s
  resources :authors, only: [:index, :show], path: "auteurices"

  # Favoris
  resources :favorites, only: [:index, :create, :destroy], path: "favoris"

  # Gestion des erreurs
  get "erreur/404", to: "errors#not_found", as: :not_found
  get "erreur/500", to: "errors#internal_server_error", as: :internal_server_error
  match "/404", to: "errors#not_found", via: :all
  match "/500", to: "errors#internal_server_error", via: :all

  # Santé de l'application (Heroku / Rails)
  get "up", to: "rails/health#show", as: :rails_health_check
  get "service-worker", to: "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest", to: "rails/pwa#manifest", as: :pwa_manifest

  # ============================================================
  # Redirections 301 (anciennes URL anglaises → nouvelles URL françaises)
  # ============================================================
  get "/bookshops", to: redirect("/librairies"), status: 301
  get "/bookshops/map", to: redirect("/librairies/autour-de-moi"), status: 301
  get "/bookshops/:id", to: redirect { |params, _| "/librairies/#{params[:id]}" }, status: 301

  get "/publishing_houses", to: redirect("/maisons-dedition"), status: 301
  get "/publishing_houses/:id", to: redirect { |params, _| "/maisons-dedition/#{params[:id]}" }, status: 301

  get "/chronicles", to: redirect("/chroniques"), status: 301
  get "/chronicles/:id", to: redirect { |params, _| "/chroniques/#{params[:id]}" }, status: 301

  get "/about", to: redirect("/a-propos"), status: 301

  get "/users/sign_in",  to: redirect("/connexion"), status: 301
  get "/users/sign_up",  to: redirect("/inscription"), status: 301
  get "/users/sign_out", to: redirect("/deconnexion"), status: 301
  get "/users/:id", to: redirect { |params, _| "/utilisateurs/#{params[:id]}" }, status: 301
end
