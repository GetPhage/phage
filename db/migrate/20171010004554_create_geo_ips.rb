class CreateGeoIps < ActiveRecord::Migration[5.1]
  def change
    create_table :geo_ips do |t|
      t.inet :ipaddr, null: false
      t.belongs_to :geo_location, foreign_key: true

      t.timestamps
    end
    add_index :geo_ips, :ipaddr
  end
end
