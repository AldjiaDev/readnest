class ChangeDefaultIsPublishingHouseForUsers < ActiveRecord::Migration[7.1]
  def change
    change_column_default :users, :is_publishing_house, from: nil, to: false
  end
end
