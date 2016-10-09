class CreateDevices < ActiveRecord::Migration[5.0]
  def change
    create_table :devices do |t|
      t.macaddr :mac_address, null: false
      t.inet :ipv4, null: true
      t.inet :ipv6, null: true
      t.string :kind, null: false
      t.timestamp :last_seen, null: false
      t.jsonb :extra, null: false, default: {}

      t.timestamps
    end

    add_index :devices, :mac_address
    add_index :devices, :ipv4
    add_index :devices, :ipv6
    add_index :devices, :kind
    add_index :devices, :extra, using: :gin
  end
end
