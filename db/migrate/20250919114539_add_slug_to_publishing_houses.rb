class AddSlugToPublishingHouses < ActiveRecord::Migration[7.2]
  def change
    add_column :publishing_houses, :slug, :string
    add_index :publishing_houses, :slug, unique: true
  end
end
