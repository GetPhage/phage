class AddStateIndexToFlows < ActiveRecord::Migration[5.1]
  def change
    add_index :flows, [ :state, :device_id ]
    add_index :partial_flows, :state
    add_index :partial_flows, [ :state, :device_id ]
  end
end
