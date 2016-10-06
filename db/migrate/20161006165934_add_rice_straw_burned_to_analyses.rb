class AddRiceStrawBurnedToAnalyses < ActiveRecord::Migration[5.0]
  def change
    add_column :analyses, :rice_straw_burned, :decimal, default: 0.0
  end
end
