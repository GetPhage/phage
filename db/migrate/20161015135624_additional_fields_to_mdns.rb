class AdditionalFieldsToMdns < ActiveRecord::Migration[5.0]
  def change
    add_column :mdns, :txt, :string, null: false
    add_column :mdns, :ipv4, :inet, array: true, default: []
    add_column :mdns, :ipv6, :inet, array: true, default: []
    add_column :mdns, :port, :integer, null: false
    add_column :mdns, :extra, :jsonb, null: false, default: {}

    rename_column :mdns, :name, :hostname

    add_index :mdns, :ipv4, using: :gin
    add_index :mdns, :ipv6, using: :gin
    add_index :mdns, :extra, using: :gin
    add_index :mdns, :port
  end
end
