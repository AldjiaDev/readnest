class AddSocialLinksToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :twitter, :string
    add_column :users, :instagram, :string
    add_column :users, :website, :string
  end
end
