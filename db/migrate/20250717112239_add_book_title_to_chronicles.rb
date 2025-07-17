class AddBookTitleToChronicles < ActiveRecord::Migration[7.2]
  def change
    add_column :chronicles, :book_title, :string
  end
end
