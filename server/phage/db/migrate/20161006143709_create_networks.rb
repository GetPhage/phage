class CreateNetworks < ActiveRecord::Migration[5.0]
  def change
    create_table :networks do |t|
      t.string :device_name, :string, null: false
      t.column :device_type, :integer, null: false

      t.string :my_ipv4, null: false
      t.string :my_ipv6, null: true
      t.string :mac_address, null: false

      t.string :my_wifi_ssid, null: true

      t.string :netmask, null: true
      t.string :default_gw, null: true

      t.timestamps
    end
  end
end
