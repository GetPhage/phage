class ChangeNamesToJsonInDevices < ActiveRecord::Migration[5.1]
  def change
    add_column :devices, :names, :jsonb, array: true, null: false, default: []
    add_index :devices, :names

    Device.all.find_each do |device|
      device.name.each do |name|
        if name.include? ".local"
          device.names.push( { scanner: 'mdns', name: name } )
        else
          device.names.push( { scanner: 'active', name: name } )
        end

        device.save
      end
    end

    remove_column :devices, :names
  end
end
