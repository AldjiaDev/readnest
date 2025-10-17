class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters, if: :devise_controller?

  def create
    super do |resource|
      if resource.persisted?
        # Messages de bienvenue adaptés au type de compte
        if resource.is_publishing_house?
          flash[:notice] = "Votre maison d’édition « #{resource.username} » a bien été créée !"
        elsif resource.is_bookshop?
          flash[:notice] = "Votre librairie « #{resource.username} » a bien été créée !"
        elsif resource.is_author?
          flash[:notice] = "Votre profil auteur·rice est prêt !"
        else
          flash[:notice] = "Merci #{resource.username} 🎉 Votre compte est créé !"
        end

        flash.keep(:notice)
      end
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(
      :sign_up,
      keys: [:username, :bio, :avatar, :is_author, :is_publishing_house, :is_bookshop]
    )

    devise_parameter_sanitizer.permit(
      :account_update,
      keys: [:username, :bio, :avatar, :is_author, :is_publishing_house, :is_bookshop]
    )
  end
end
