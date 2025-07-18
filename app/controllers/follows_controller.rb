class FollowsController < ApplicationController
  before_action :authenticate_user!

  def create
    followable = find_followable
    current_user.follows.create(followable: followable)
    redirect_back fallback_location: root_path, notice: "Abonnement effectué."
  end

  def destroy
    follow = current_user.follows.find_by(followable_type: params[:type], followable_id: params[:id])
    follow&.destroy
    redirect_back fallback_location: root_path, notice: "Abonnement annulé."
  end

  private

  def find_followable
    params[:type].constantize.find(params[:id])
  end
end
