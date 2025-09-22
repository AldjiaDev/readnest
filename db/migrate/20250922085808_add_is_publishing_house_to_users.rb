class AddIsPublishingHouseToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :is_publishing_house, :boolean, default: false
  end
end
