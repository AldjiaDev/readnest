class AddCaptionToChronicles < ActiveRecord::Migration[7.2]
  def change
    add_column :chronicles, :caption, :string
  end
end
