class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = current_user.received_notifications.order(created_at: :desc)
  end

  # Marquer toutes les notifications comme lues
  def mark_as_read
    current_user.received_notifications.update_all(read: true)
    redirect_to notifications_path, notice: "Toutes vos notifications ont été marquées comme lues."
  end
end
