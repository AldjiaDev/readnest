class AddSlugToChronicles < ActiveRecord::Migration[7.2]
  def change
    add_column :chronicles, :slug, :string
    add_index :chronicles, :slug, unique: true
  end
end
