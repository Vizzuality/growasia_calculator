class AddCropToAnalyses < ActiveRecord::Migration[5.0]
  def change
    add_column :analyses, :crop, :string
  end
end
