class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :prepare_meta_tags, if: -> { request.get? }

  def prepare_meta_tags(options = {})
    site_name   = "Readnest"
    title       = options[:title] || "Readnest — Découvrez, partagez, célébrez la lecture"
    description = options[:description] || "Readnest connecte lecteurs et maisons d’édition à travers des chroniques littéraires."
    image       = options[:image] || view_context.asset_url("logo.jpg")
    current_url = request.url

    defaults = {
      site: site_name,
      title: title,
      description: description,
      image: image,
      keywords: %w[littérature livres chroniques auteurs maisons d’édition lecture],
      twitter: {
        card: "summary_large_image",
        site: "@Readnest",
        title: title,
        description: description,
        image: image
      },
      og: {
        url: current_url,
        site_name: site_name,
        title: title,
        description: description,
        type: "website",
        image: image
      }
    }

    set_meta_tags defaults
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :is_publishing_house, :avatar])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :is_publishing_house, :avatar])
  end

  # Redirection après connexion/inscription
  def after_sign_in_path_for(resource)
    if resource.is_publishing_house? && resource.publishing_house.present?
      publishing_house_path(resource.publishing_house)
    else
      user_path(resource)
    end
  end

  # Redirection après mise à jour du profil
  def after_update_path_for(resource)
    if resource.is_publishing_house? && resource.publishing_house.present?
      publishing_house_path(resource.publishing_house)
    else
      user_path(resource)
    end
  end
end
