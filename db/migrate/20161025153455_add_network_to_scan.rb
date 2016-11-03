class AddNetworkToScan < ActiveRecord::Migration[5.0]
  def change
    add_reference :scans, :network, foreign_key: true
  end
end
