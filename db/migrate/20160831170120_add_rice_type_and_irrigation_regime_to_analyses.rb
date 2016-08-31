class AddRiceTypeAndIrrigationRegimeToAnalyses < ActiveRecord::Migration[5.0]
  def change
    add_column :analyses, :rice_type, :string
    add_column :analyses, :irrigation_regime, :string
  end
end
