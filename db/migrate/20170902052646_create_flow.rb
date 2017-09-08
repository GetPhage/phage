class CreateFlow < ActiveRecord::Migration[5.0]
  def change
    create_table :flows do |t|
      t.belongs_to :device
      t.macaddr :mac_address, null: false
      t.inet :src_ip, null: false, default: '0.0.0.0'
      t.inet :dst_ip, null: false, default: '0.0.0.0'
      t.integer :src_port, null: false, default: 0
      t.integer :dst_port, null: false, default: 0
      t.string :hostname, null: false, default: ''
      t.integer :duration, null: false, default: 0
      t.integer :bytes_sent, null: false, default: 0, :limit => 8
      t.integer :bytes_received, null: false, default: 0, :limit => 8
    end
    add_index :flows, :src_ip
    add_index :flows, :dst_ip
    add_index :flows, :src_port
    add_index :flows, :dst_port
    add_index :flows, :hostname
    add_index :flows, :duration
    add_index :flows, :bytes_received
  end
end
