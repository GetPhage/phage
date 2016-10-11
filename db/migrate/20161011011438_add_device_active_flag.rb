class AddDeviceActiveFlag < ActiveRecord::Migration[5.0]
  def change
    add_column :devices, :active, :boolean, null: false, default: true
  end
end
