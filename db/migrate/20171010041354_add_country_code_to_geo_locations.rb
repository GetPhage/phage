class AddCountryCodeToGeoLocations < ActiveRecord::Migration[5.1]
  def change
    add_column :geo_locations, :country_code, :string, null: false
  end
end
