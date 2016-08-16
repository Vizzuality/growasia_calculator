class CreateGeoLocations < ActiveRecord::Migration[5.0]
  def change
    create_table :geo_locations do |t|
      t.string :country
      t.string :state
      t.numeric :soc_ref
      t.string :flu
      t.numeric :fmg_full
      t.numeric :fmg_reduced
      t.numeric :fmg_no_till
      t.numeric :fl_low
      t.numeric :fl_high_without_manure
      t.numeric :fl_high_with_manure

      t.timestamps
    end
  end
end
