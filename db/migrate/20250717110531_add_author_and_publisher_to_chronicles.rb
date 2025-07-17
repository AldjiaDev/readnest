class AddAuthorAndPublisherToChronicles < ActiveRecord::Migration[7.2]
  def change
    add_column :chronicles, :author, :string
    add_column :chronicles, :publisher, :string
  end
end
