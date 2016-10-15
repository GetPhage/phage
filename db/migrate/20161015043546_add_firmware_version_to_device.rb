class AddFirmwareVersionToDevice < ActiveRecord::Migration[5.0]
  def change
    add_column :devices, :firmware_version, :string
    add_index :devices, :firmware_version
  end
end
