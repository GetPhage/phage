class AddIndicesToPartialFlows < ActiveRecord::Migration[5.0]
  def change
    add_index :partial_flows, [:is_syn, :src_ip, :dst_ip, :src_port, :dst_port, :timestamp], name: :partial_flow_syn_hosts_index
    add_index :partial_flows, [:is_fin, :src_ip, :dst_ip, :src_port, :dst_port, :timestamp], name: :partial_flow_fin_hosts_index
    add_index :partial_flows, :is_fin
    add_index :partial_flows, :is_syn
  end
end
