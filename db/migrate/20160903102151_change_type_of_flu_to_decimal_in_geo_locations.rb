class ChangeTypeOfFluToDecimalInGeoLocations < ActiveRecord::Migration[5.0]
  def change
    change_column :geo_locations, :flu, 'decimal USING CAST(flu AS decimal)'
  end
end
