class AddDefaultToDeviceNames < ActiveRecord::Migration[5.0]
  def up
    say_with_time 'Fixing null device names'
    Device.where(name: nil) { |device| device.update(name: []) }

  end
  def change
    change_column :devices, :name, :string, array: true, default: [], null: false
  end
end
