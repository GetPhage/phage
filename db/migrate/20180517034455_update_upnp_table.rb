class UpdateUpnpTable < ActiveRecord::Migration[5.1]
  def change
    add_column :upnps, :description, :string, null: false
    add_column :upnps, :services, :string, null: false, array: true

    remove_column :upnps, :st
    remove_column :upnps, :usn
    remove_column :upnps, :cache_control
    remove_column :upnps, :server
    remove_column :upnps, :ext
    remove_column :upnps, :location
  end
end
