class CreateAnalyses < ActiveRecord::Migration[5.0]
  def change
    create_table :analyses do |t|
      t.integer :geo_location_id
      t.numeric :area
      t.numeric :yield
      t.boolean :is_shaded

      t.timestamps
    end
  end
end
