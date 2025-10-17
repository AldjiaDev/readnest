class AddDescriptionToBookshops < ActiveRecord::Migration[7.2]
  def change
    add_column :bookshops, :description, :text
  end
end
