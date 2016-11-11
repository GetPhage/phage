class AddNetworkToDevice < ActiveRecord::Migration[5.0]
  def change
    add_reference :devices, :network, foreign_key: true
  end
end
