class AddMetadataToDevice < ActiveRecord::Migration[5.0]
  def change
    add_column :devices, :serial_number, :string
    add_column :devices, :model_number, :string
    add_column :devices, :model_name, :string
    add_column :devices, :upc, :string
    add_index :devices, :upc
    add_column :devices, :model_description, :string
    add_index :devices, :model_description
  end
end
