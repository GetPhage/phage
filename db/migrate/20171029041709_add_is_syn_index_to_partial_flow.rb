class AddIsSynIndexToPartialFlow < ActiveRecord::Migration[5.1]
  def change
    add_index :partial_flows, [ :is_syn, :src_ack, :state ]
  end
end
