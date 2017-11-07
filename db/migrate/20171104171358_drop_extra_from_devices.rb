class DropExtraFromDevices < ActiveRecord::Migration[5.1]
  def change
    remove_column :devices, :extra
  end
end
