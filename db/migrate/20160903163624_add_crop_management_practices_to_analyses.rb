class AddCropManagementPracticesToAnalyses < ActiveRecord::Migration[5.0]
  def change
    add_column :analyses, :crop_management_practices, :string, array: true
  end
end
