class AddIsBookshopToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :is_bookshop, :boolean
  end
end
