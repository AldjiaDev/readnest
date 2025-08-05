class UsersController < ApplicationController
  def show
    unless valid_integer_id?(params[:id])
      redirect_to root_path and return
    end

    @user = User.find_by(id: params[:id])

    unless @user
      redirect_to root_path, alert: "Utilisateur introuvable."
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to @user, notice: "Profil mis à jour avec succès."
    else
      render :edit
    end
  end

  private

  def valid_integer_id?(value)
    value.to_i.to_s == value
  end

  def user_params
    params.require(:user).permit(:username, :bio, :avatar, :facebook_url, :twitter_url, :instagram_url)
  end
end
