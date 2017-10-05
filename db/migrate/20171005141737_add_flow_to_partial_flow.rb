class AddFlowToPartialFlow < ActiveRecord::Migration[5.1]
  def change
    add_reference :partial_flows, :flow, foreign_key: true
  end
end
