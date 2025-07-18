class UsersController < ApplicationController
  def show
    unless valid_integer_id?(params[:id])
      redirect_to root_path and return
    end

    @user = User.find(params[:id])
  end

  def show
    @user = User.find_by(id: params[:id])

    unless @user
      redirect_to root_path, alert: "Utilisateur introuvable."
    end
  end

  private

  def valid_integer_id?(value)
    value.to_i.to_s == value
  end
end
