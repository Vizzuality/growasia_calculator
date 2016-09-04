class RenameColumnsInGeoLocations < ActiveRecord::Migration[5.0]
  def change
    rename_column :geo_locations, :fl_low, :fi_low
    rename_column :geo_locations, :fl_high_without_manure, :fi_high_wo_manure
    rename_column :geo_locations, :fl_high_with_manure, :fi_high_w_manure
  end
end
