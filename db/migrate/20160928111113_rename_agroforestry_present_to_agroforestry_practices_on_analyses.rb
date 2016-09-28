class RenameAgroforestryPresentToAgroforestryPracticesOnAnalyses < ActiveRecord::Migration[5.0]
  def change
    rename_column :analyses, :agroforestry_present, :agroforestry_practices
  end
end
