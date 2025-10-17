class AddSlugToBookshops < ActiveRecord::Migration[7.2]
  def change
    add_column :bookshops, :slug, :string
    add_index :bookshops, :slug, unique: true
  end
end
