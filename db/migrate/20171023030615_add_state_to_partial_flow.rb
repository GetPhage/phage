class AddStateToPartialFlow < ActiveRecord::Migration[5.1]
  def change
    add_column :partial_flows, :state, :integer, null: false, default: 1
    add_index :partial_flows, [ :state, :timestamp, :src_ip, :src_port, :dst_ip, :dst_port ], name: :partial_flows_important_index
  end
end
