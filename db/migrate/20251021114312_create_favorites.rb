class CreateFavorites < ActiveRecord::Migration[7.2]
  def change
    create_table :favorites do |t|
      t.references :user, null: false, foreign_key: true
      t.references :chronicle, null: false, foreign_key: true

      t.timestamps
    end

    # Empêche les doublons (un favori par user/chronicle)
    add_index :favorites, [:user_id, :chronicle_id], unique: true
  end
end
