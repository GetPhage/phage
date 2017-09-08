class CreatePartialFlow < ActiveRecord::Migration[5.0]
  def change
    create_table :partial_flows do |t|
      t.belongs_to :device
      t.macaddr :mac_address, null: false
      t.inet :src_ip, null: false, default: '0.0.0.0'
      t.inet :dst_ip, null: false, default: '0.0.0.0'
      t.integer :src_port, null: false, default: 0
      t.integer :dst_port, null: false, default: 0
      t.string :hostname, null: false, default: ''
      t.integer :src_seq, null: false, default: 0, :limit => 8
      t.integer :src_ack, null: false, default: 0, :limit => 8
      t.integer :dst_seq, null: false, default: 0, :limit => 8
      t.integer :dst_ack, null: false, default: 0, :limit => 8
      t.boolean :src_syn, null: false, default: false
      t.boolean :src_fin, null: false, default: false
      t.boolean :src_rst, null: false, default: false
      t.boolean :dst_syn, null: false, default: false
      t.boolean :dst_fin, null: false, default: false
      t.boolean :dst_rst, null: false, default: false
      t.datetime :timestamp,  null: false
    end
    add_index :partial_flows, [ :src_ip, :dst_ip, :src_port, :dst_port ], name: :partial_flow_index
  end
end
