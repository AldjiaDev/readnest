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
    Rails.logger.info "=== DEBUG params in LikesController ==="
    Rails.logger.info params.to_unsafe_h
    @chronicle = Chronicle.friendly.find(params[:chronicle_id])
  rescue ActiveRecord::RecordNotFound
    Rails.logger.error "=== CHRONICLE NOT FOUND: #{params[:chronicle_id].inspect} ==="
    head :not_found
  end
end

