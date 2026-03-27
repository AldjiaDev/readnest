class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chronicle

  def create
    like = @chronicle.likes.find_or_create_by(user: current_user)

    if like.previously_new_record? && @chronicle.user != current_user
      Notification.create(recipient: @chronicle.user, actor: current_user, action: "liked", notifiable: @chronicle)
      PushNotificationService.send_to_user(
        @chronicle.user,
        title: "Quelqu'un a aimé votre chronique",
        body:  "#{current_user.username} a aimé « #{@chronicle.title} »",
        path:  chronicle_path(@chronicle)
      )
    end

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
    @chronicle = Chronicle.friendly.find(params[:chronicle_slug])
  rescue ActiveRecord::RecordNotFound
    head :not_found
  end
end

