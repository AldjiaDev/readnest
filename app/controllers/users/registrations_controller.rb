class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters, if: :devise_controller?

  def create
    super do |resource|
      if resource.persisted?
        flash[:notice] = "Merci #{resource.username} 🎉 Votre compte est créé ! Vous pouvez maintenant vous connecter, lire et écrire vos chroniques."
        flash.keep(:notice)
      end
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :bio, :avatar])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :bio, :avatar])
  end
end
