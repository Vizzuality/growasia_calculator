class AddTillageToAnalyses < ActiveRecord::Migration[5.0]
  def change
    add_column :analyses, :tillage, :string
  end
end
