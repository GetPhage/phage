class AddMobileToDevices < ActiveRecord::Migration[5.1]
  def change
    add_column :devices, :is_mobile, :boolean, null: false, default: false
    add_index :devices, :is_mobile
  end
end
