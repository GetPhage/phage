class AddPortsToDevices < ActiveRecord::Migration[5.0]
  def change
    add_column :devices, :udpv4, :integer, array: true, default: []
    add_column :devices, :tcpv4, :integer, array: true, default: []
    add_column :devices, :udpv6, :integer, array: true, default: []
    add_column :devices, :tcpv6, :integer, array: true, default: []

    add_index :devices, :udpv4, using: :gin
    add_index :devices, :tcpv4, using: :gin
    add_index :devices, :udpv6, using: :gin
    add_index :devices, :tcpv6, using: :gin
  end
end
