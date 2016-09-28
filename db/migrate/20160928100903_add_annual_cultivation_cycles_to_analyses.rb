class AddAnnualCultivationCyclesToAnalyses < ActiveRecord::Migration[5.0]
  def change
    add_column :analyses, :annual_cultivation_cycles, :integer
  end
end
