class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    chronicle = Chronicle.find(params[:chronicle_id])
    chronicle.likes.create(user: current_user)
    redirect_back fallback_location: root_path
  end

  def destroy
    chronicle = Chronicle.find(params[:chronicle_id])
    like = chronicle.likes.find_by(user: current_user)
    like.destroy if like
    redirect_back fallback_location: root_path
  end
end
