class UsersController < ApplicationController
  def show
    @user = User.friendly.find(params[:id])
    @chronicles = @user.chronicles.order(created_at: :desc)

    # Meta tags pour SEO et partage social
    prepare_meta_tags(
      title: @user.username,
      description: @user.bio.presence || "Découvrez le profil de #{@user.username} sur Readnest.",
      image: @user.avatar.attached? ? url_for(@user.avatar) : view_context.asset_url("logo.jpg")
    )

  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "Utilisateur introuvable."
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to @user, notice: "Profil mis à jour avec succès ✨"
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
      :instagram,
      :links,
      :is_author,
      :is_bookshop,
      :is_publishing_house
    )
  end
end
