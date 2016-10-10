class CreateSamples < ActiveRecord::Migration[5.0]
  def change
    create_table :samples do |t|
      t.integer :device_id, null: false

      t.string :mac_address, null: false
      t.string  :ipv4, null: true
      t.string :ipv6, null: true
      t.integer :signal_strength, null: true

      t.index :device_id
      t.index :mac_address
      t.index :ipv4
      t.index :ipv6
      t.index :signal_strength

      t.timestamps
    end
  end
end
