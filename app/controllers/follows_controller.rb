class FollowsController < ApplicationController
  before_action :authenticate_user!

  def create
    followable = find_followable
    current_user.follows.create(followable: followable)

    if followable.is_a?(User) && followable != current_user
      Notification.create(recipient: followable, actor: current_user, action: "followed", notifiable: followable)
      PushNotificationService.send_to_user(
        followable,
        title: "Nouvel abonné",
        body:  "#{current_user.username} s'est abonné à votre profil",
        path:  user_path(followable)
      )
    end

    redirect_back fallback_location: root_path, notice: "Abonnement effectué."
  end

  def destroy
    follow = current_user.follows.find_by(
      followable_type: params[:followable_type],
      followable_id: params[:followable_id]
    )
    follow&.destroy
    redirect_back fallback_location: root_path, notice: "Abonnement annulé."
  end

  private

  def find_followable
    params[:followable_type].constantize.find(params[:followable_id])
  end
end
