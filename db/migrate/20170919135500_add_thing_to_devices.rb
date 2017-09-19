class AddThingToDevices < ActiveRecord::Migration[5.1]
  def change
    add_column :devices, :is_thing, :boolean, null: false, default: false
    add_index :devices, :is_thing
  end
end
