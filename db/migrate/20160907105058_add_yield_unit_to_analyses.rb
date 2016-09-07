class AddYieldUnitToAnalyses < ActiveRecord::Migration[5.0]
  def change
    add_column :analyses, :yield_unit, :string
  end
end
