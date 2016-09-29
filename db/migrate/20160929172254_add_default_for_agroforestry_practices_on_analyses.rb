class AddDefaultForAgroforestryPracticesOnAnalyses < ActiveRecord::Migration[5.0]
  def change
    change_column :analyses, :agroforestry_practices, :boolean, default: false
  end
end
