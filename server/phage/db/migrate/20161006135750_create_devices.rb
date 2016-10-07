class CreateDevices < ActiveRecord::Migration[5.0]
  def change
#    enable_extension "hstore"

    create_table :devices do |t|
      t.macaddr :mac_address
      t.inet :ipv4
      t.inet :ipv6
      t.string :kind
      t.timestamp :last_seen
      t.jsonb :extra

      t.timestamps
    end
    add_index :devices, :mac_address
    add_index :devices, :ipv4
    add_index :devices, :ipv6
    add_index :devices, :kind
    add_index :devices, :extra, using: :gin
  end
end
