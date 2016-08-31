class AddFloodingAndCultivationTimeToAnalyses < ActiveRecord::Migration[5.0]
  def change
    add_column :analyses, :flooding, :string
    add_column :analyses, :cultivation_time, :integer
  end
end
