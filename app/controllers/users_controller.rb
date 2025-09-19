class UsersController < ApplicationController
  def show
    @user = User.friendly.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "Utilisateur introuvable."
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

  def user_params
    params.require(:user).permit(
      :username,
      :bio,
      :avatar,
      :website,
      :twitter,
      :instagram
    )
  end
end
