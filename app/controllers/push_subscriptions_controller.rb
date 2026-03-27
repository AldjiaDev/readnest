class PushSubscriptionsController < ApplicationController
  before_action :authenticate_user!

  def create
    subscription = current_user.push_subscriptions.find_or_initialize_by(endpoint: params[:endpoint])
    subscription.p256dh_key = params.dig(:keys, :p256dh)
    subscription.auth_key   = params.dig(:keys, :auth)

    if subscription.save
      head :created
    else
      head :unprocessable_entity
    end
  end

  def destroy
    current_user.push_subscriptions.find_by(endpoint: params[:endpoint])&.destroy
    head :no_content
  end
end
