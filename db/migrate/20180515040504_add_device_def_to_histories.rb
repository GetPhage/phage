class AddDeviceDefToHistories < ActiveRecord::Migration[5.1]
  def change
    add_reference :histories, :device, foreign_key: true
  end
end
