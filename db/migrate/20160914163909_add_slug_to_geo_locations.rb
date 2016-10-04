class AddSlugToGeoLocations < ActiveRecord::Migration[5.0]
  def change
    add_column :geo_locations, :slug, :string
    GeoLocation.all.each do |gl|
      gl.update_attributes(slug: "#{gl.country.gsub(" ", "-").downcase}-#{gl.state.gsub(" ", "-").gsub(/[^0-9A-Za-z]/, '').downcase}")
    end
  end
end
