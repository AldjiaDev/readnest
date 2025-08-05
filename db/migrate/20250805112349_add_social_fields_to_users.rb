class AddSocialFieldsToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :location, :string
    add_column :users, :facebook_url, :string
    add_column :users, :twitter_url, :string
    add_column :users, :instagram_url, :string
  end
end
