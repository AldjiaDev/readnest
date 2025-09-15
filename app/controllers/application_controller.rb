class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    # Autoriser username à l'inscription
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])

    # Autoriser username à la modification du compte
    devise_parameter_sanitizer.permit(:account_update, keys: [:username])
  end
end
