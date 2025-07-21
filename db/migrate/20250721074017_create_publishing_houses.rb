class CreatePublishingHouses < ActiveRecord::Migration[7.2]
  def change
    create_table :publishing_houses do |t|
      t.string :name
      t.text :description
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
