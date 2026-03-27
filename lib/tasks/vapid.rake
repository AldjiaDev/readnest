namespace :webpush do
  desc "Generate VAPID keys for Web Push notifications"
  task generate_vapid_keys: :environment do
    require "webpush"
    vapid_key = WebPush.generate_key
    puts ""
    puts "=== VAPID Keys generated — add these to your environment ==="
    puts ""
    puts "VAPID_PUBLIC_KEY=#{vapid_key.public_key}"
    puts "VAPID_PRIVATE_KEY=#{vapid_key.private_key}"
    puts ""
    puts "For Heroku:"
    puts "  heroku config:set VAPID_PUBLIC_KEY='#{vapid_key.public_key}'"
    puts "  heroku config:set VAPID_PRIVATE_KEY='#{vapid_key.private_key}'"
    puts ""
    puts "For .env (development):"
    puts "  VAPID_PUBLIC_KEY=#{vapid_key.public_key}"
    puts "  VAPID_PRIVATE_KEY=#{vapid_key.private_key}"
    puts ""
  end
end
