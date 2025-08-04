class AddSummaryToChronicles < ActiveRecord::Migration[7.2]
  def change
    add_column :chronicles, :summary, :text
  end
end
