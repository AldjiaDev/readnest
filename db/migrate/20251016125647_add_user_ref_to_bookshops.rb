class AddUserRefToBookshops < ActiveRecord::Migration[7.2]
  def change
    add_reference :bookshops, :user, null: false, foreign_key: true
  end
end
