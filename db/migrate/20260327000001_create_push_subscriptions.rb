class CreatePushSubscriptions < ActiveRecord::Migration[7.2]
  def change
    create_table :push_subscriptions do |t|
      t.references :user, null: false, foreign_key: true
      t.text :endpoint, null: false
      t.text :p256dh_key
      t.text :auth_key
      t.timestamps
    end

    add_index :push_subscriptions, :endpoint, unique: true
  end
end
