class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = current_user.received_notifications.order(created_at: :desc)
  end

  def mark_as_read
    @notification = current_user.received_notifications.find(params[:id])
    @notification.update(read: true)
    redirect_to polymorphic_path(@notification.notifiable)
  end
end
