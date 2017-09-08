class RemoveUnusedColumnsFromPartialFlow < ActiveRecord::Migration[5.0]
  def change
    remove_column :partial_flows, :dst_seq
    remove_column :partial_flows, :dst_ack
    remove_column :partial_flows, :dst_syn
    remove_column :partial_flows, :dst_fin
    remove_column :partial_flows, :dst_rst
    rename_column :partial_flows, :src_syn, :is_syn
    rename_column :partial_flows, :src_fin, :is_fin
    rename_column :partial_flows, :src_rst, :is_rst
  end
end
