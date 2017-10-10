class CreateGeoLocations < ActiveRecord::Migration[5.1]
  def change
    create_table :geo_locations do |t|
      t.integer :geoname_id, null: false
      t.string :continent, null: false
      t.string :country, null: false

      t.timestamps
    end
    add_index :geo_locations, :geoname_id
  end
end
