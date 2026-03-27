class PushNotificationService
  VAPID_SUBJECT = "mailto:contact.readnest@gmail.com"

  def self.send_to_user(user, title:, body:, path: "/")
    return if ENV["VAPID_PUBLIC_KEY"].blank? || ENV["VAPID_PRIVATE_KEY"].blank?

    user.push_subscriptions.each do |subscription|
      WebPush.payload_send(
        message: JSON.generate({ title: title, body: body, path: path }),
        endpoint: subscription.endpoint,
        p256dh: subscription.p256dh_key,
        auth: subscription.auth_key,
        vapid: {
          subject: VAPID_SUBJECT,
          public_key: ENV["VAPID_PUBLIC_KEY"],
          private_key: ENV["VAPID_PRIVATE_KEY"]
        }
      )
    rescue WebPush::ExpiredSubscription, WebPush::InvalidSubscription
      subscription.destroy
    rescue => e
      Rails.logger.error "[PushNotification] Error for subscription #{subscription.id}: #{e.message}"
    end
  end
end
