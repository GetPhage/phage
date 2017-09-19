class AddGivenNameToDevices < ActiveRecord::Migration[5.1]
  def change
    add_column :devices, :given_name, :string, null: false, default: ''
    add_index :devices, :given_name
  end
end
