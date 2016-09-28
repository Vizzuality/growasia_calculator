class RenameIsShadedToAgroforestryPresentOnAnalyses < ActiveRecord::Migration[5.0]
  def up
    rename_column :analyses, :is_shaded, :agroforestry_present
    change_column :analyses, :agroforestry_present, :boolean, default: false
  end

  def down
    rename_column :analyses, :agroforestry_present, :is_shaded
    change_column :analyses, :is_shaded, :boolean
  end
end
