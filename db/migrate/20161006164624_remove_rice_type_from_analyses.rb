class RemoveRiceTypeFromAnalyses < ActiveRecord::Migration[5.0]
  def change
    remove_column :analyses, :rice_type, :string
  end
end
