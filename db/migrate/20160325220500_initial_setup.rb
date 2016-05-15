ActiveSupport::Inflector.inflections do |inflect|
  inflect.irregular 'mdns', 'mdns'
end

class InitialSetup < ActiveRecord::Migration[5.0]
  def change
    enable_extension 'hstore'
    
    create_table :network do |t|
      t.string :device_name, :string, null: false
      t.column :device_type, :integer, null: false

      t.string :my_ipv4, null: false
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
      t.string :kind
      t.timestamp :last_seen

      t.timestamps null: false

      t.index :mac_address
      t.index :ipv4
      t.index :ipv6
      t.index :kind
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

    create_table :scans do |t|
      t.string :scan_type

      t.timestamp :start
      t.timestamp :end

      t.string :notes
      
      t.timestamps null: false

      t.index :scan_type
    end

    create_table :scan_diffs do |t|
      t.integer :scan_id, null: false
      t.integer :device_id, null: true

      t.string :kind, null: false
      #      t.enum :status, [ :added, :removed, :changed ], null: false
      t.column :status, :integer, null: false

      # hstore
      t.hstore :data, null: true

      t.index :scan_id
      t.index :device_id
      t.index :kind
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

    create_table :software_blacklists do |t|
      t.string :name
      t.string :version
      t.string :reason

      t.timestamps null: false

      t.index :name
      t.index :version
    end

    create_table :upnps do |t|
      t.string :uuid

      t.integer :device_id, null: true
      t.timestamp :last_seen

      t.timestamps null: false

      t.index :uuid
      t.index :last_seen
    end

    create_table :upnp_services do |t|
      t.string :name, null: false

      t.timestamps null: false

      t.index :name
    end

    create_table :upnp_service_maps do |t|
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

    create_table :mdns_services do |t|
      t.string :name, null: false

      t.timestamps null: false

      t.index :name
    end

    create_table :mdns_service_maps do |t|
      t.integer :mdns_id
      t.integer :mdns_service_id

      t.timestamps null: false

      t.index :mdns_id
      t.index :mdns_service_id
    end

    add_foreign_key :samples, :devices
    add_foreign_key :software_versions, :devices

    add_foreign_key :scan_diffs, :scans
    add_foreign_key :scan_diffs, :devices

    add_foreign_key :upnps, :devices
    add_foreign_key :mdns, :devices

    add_foreign_key :upnp_service_maps, :upnps
    add_foreign_key :upnp_service_maps, :upnp_services

    add_foreign_key :mdns_service_maps, :mdns
    add_foreign_key :mdns_service_maps, :mdns_services
  end

  def down
    drop_table :devices
    drop_table :samples

    drop_table :scans
    drop_table :scan_diffs

    drop_table :software_versions
    drop_table :software_blacklists

    drop_table :upnps
    drop_table :upnp_services
    drop_table :upnp_service_maps

    drop_table :mdnss
    drop_table :mdns_services
    drop_table :mdns_service_maps

    remove_foreign_key :samples, :devices
    remove_foreign_key :software_versions, :devices

    remove_foreign_key :scan_diffs, :scan
    remove_foreign_key :scan_diffs, :device

    remove_foreign_key :upnps, :devices
    remove_foreign_key :mdns, :devices
s
    remove_foreign_key :upnp_service_maps, :upnps
    remove_foreign_key :upnp_service_maps, :upnp_services

    remove_foreign_key :mdns_service_maps, :mdns
    remove_foreign_key :mdns_service_maps, :mdns_services
  end

end
