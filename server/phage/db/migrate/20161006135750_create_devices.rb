class CreateDevices < ActiveRecord::Migration[5.0]
  def change
    create_table :devices do |t|
      t.mac_address :mac_address
      t.ip_address :ipv4
      t.ip_address :ipv6
      t.string :kind
      t.timestamp :last_seen
      t.hstore :extra

      t.timestamps
    end
    add_index :devices, :mac_address
    add_index :devices, :ipv4
    add_index :devices, :ipv6
    add_index :devices, :kind
    add_index :devices, :extra
  end
end
