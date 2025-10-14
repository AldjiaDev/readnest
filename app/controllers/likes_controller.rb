class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chronicle

  def create
    @chronicle.likes.find_or_create_by(user: current_user)

    respond_to do |format|
      format.html { redirect_back fallback_location: root_path }
      format.turbo_stream
    end
  end

  def destroy
    @chronicle.likes.find_by(user: current_user)&.destroy

    respond_to do |format|
      format.html { redirect_back fallback_location: root_path }
      format.turbo_stream
    end
  end

  private

  def set_chronicle
    @chronicle = Chronicle.find(params[:chronicle_id])
  end
end

