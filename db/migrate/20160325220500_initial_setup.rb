ActiveSupport::Inflector.inflections do |inflect|
  inflect.irregular 'mdns', 'mdns'
end

class InitialSetup < ActiveRecord::Migration[5.0]
  def change
    enable_extension 'hstore'
    
    create_table :network do |t|
      t.string :device_name, :string, null: false
      t.column :device_type, :integer, null: false

      t.string :my_ip, null: false
      t.string :my_ipv6, null: true
      t.string :mac_address, null: false

      t.string :my_wifi_ssid, null: true

      t.string :netmask, null: true
      t.string :default_gw, null: true

      t.timestamps null: false
    end

    create_table :devices do |t|
      t.column :mac_address, :string, null: false
      t.string :ipv4, null: true
      t.string :ipv6, null: true
      t.string :type
      t.timestamp :last_seen

      t.timestamps null: false

      t.index :mac_address
      t.index :ipv4
      t.index :ipv6
      t.index :type
      t.index :last_seen
    end

    create_table :samples do |t|
      t.integer :device_id

      t.string :mac_address, null: false
      t.string  :ipv4, null: true
      t.string :ipv6, null: true
      t.integer :signal_strength

      t.index :device_id
      t.index :mac_address
      t.index :ipv4
      t.index :ipv6
      t.index :signal_strength

      t.timestamps null: false
    end

    create_table :scan do |t|
      t.string :scan_type

      t.timestamp :start
      t.timestamp :end

      t.string :notes
      
      t.timestamps null: false

      t.index :scan_type
    end

    create_table :scan_diff do |t|
      t.integer :scan_id, null: false
      t.integer :device_id, null: true

      t.string :type, null: false
      #      t.enum :status, [ :added, :removed, :changed ], null: false
      t.column :status, :integer, null: false

      # hstore
      t.hstore :data, null: true

      t.index :scan_id
      t.index :device_id
      t.index :type
      t.index :data, using: :gin
    end

    create_table :software_versions do |t|
      t.integer :device_id
      t.string :name
      t.string :version

      t.timestamps null: false

      t.index :name
      t.index :version
    end

    create_table :software_blacklist do |t|
      t.string :name
      t.string :version
      t.string :reason

      t.timestamps null: false

      t.index :name
      t.index :version
    end

    create_table :upnp do |t|
      t.string :uuid

      t.integer :device_id, null: true
      t.timestamp :last_seen

      t.timestamps null: false

      t.index :uuid
      t.index :last_seen
    end

    create_table :upnp_service do |t|
      t.string :name, null: false

      t.timestamps null: false

      t.index :name
    end

    create_table :upnp_service_map do |t|
      t.integer :upnp_id
      t.integer :upnp_service_id

      t.timestamps null: false

      t.index :upnp_id
      t.index :upnp_service_id
    end

    create_table :mdns do |t|
      t.string :name
      t.string :service
      t.string :protocol

      t.integer :device_id, null: true
      t.timestamp :last_seen

      t.timestamps null: false

      t.index :name
      t.index :service
      t.index :protocol
      t.index :last_seen
    end

    create_table :mdns_service do |t|
      t.string :name, null: false

      t.timestamps null: false

      t.index :name
    end

    create_table :mdns_service_map do |t|
      t.integer :mdns_id
      t.integer :mdns_service_id

      t.timestamps null: false

      t.index :mdns_id
      t.index :mdns_service_id
    end

    add_foreign_key :samples, :devices
    add_foreign_key :software_versions, :devices

    add_foreign_key :scan_diff, :scan
    add_foreign_key :scan_diff, :devices

    add_foreign_key :upnp, :devices
    add_foreign_key :mdns, :devices

    add_foreign_key :upnp_service_map, :upnp
    add_foreign_key :upnp_service_map, :upnp_service

    add_foreign_key :mdns_service_map, :mdns
    add_foreign_key :mdns_service_map, :mdns_service
  end

  def down
    drop_table :devices
    drop_table :samples

    drop_table :scan
    drop_table :scan_diff

    drop_table :software_versions
    drop_table :software_blacklist

    drop_table :upnp
    drop_table :upnp_services
    drop_table :upnp_service_map

    drop_table :mdns
    drop_table :mdns_services
    drop_table :mdns_service_map

    remove_foreign_key :samples, :devices
    remove_foreign_key :software_versions, :devices

    remove_foreign_key :scan_diff, :scan
    remove_foreign_key :scan_diff, :device

    remove_foreign_key :upnp, :devices
    remove_foreign_key :mdns, :devices

    remove_foreign_key :upnp_service_map, :upnp
    remove_foreign_key :upnp_service_map, :upnp_services

    remove_foreign_key :mdns_service_map, :mdns
    remove_foreign_key :mdns_service_map, :mdns_services
  end

end
