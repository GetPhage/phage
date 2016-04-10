class UpnpMdns < ActiveRecord::Migration
  def up
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

    add_foreign_key :upnp, :devices
    add_foreign_key :mdns, :devices

    add_foreign_key :upnp_service_map, :upnp
    add_foreign_key :upnp_service_map, :upnp_services

    add_foreign_key :mdns_service_map, :mdns
    add_foreign_key :mdns_service_map, :mdns_services
  end

  def down
    drop_table :upnp
    drop_table :upnp_services
    drop_table :upnp_service_map

    drop_table :mdns
    drop_table :mdns_services
    drop_table :mdns_service_map
  end
end
    
