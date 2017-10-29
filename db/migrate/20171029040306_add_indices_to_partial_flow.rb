class AddIndicesToPartialFlow < ActiveRecord::Migration[5.1]
  def change
    add_index :partial_flows, [ :is_syn, :state ]
    add_index :partial_flows, [ :src_ip, :dst_ip, :src_port, :dst_port, :state ], name: 'identify_index'
  end
end
