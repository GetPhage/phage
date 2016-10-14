class CreateUpnps < ActiveRecord::Migration[5.0]
  def change
    create_table :upnps do |t|
      t.belongs_to :device, foreign_key: true
      t.string :st
      t.string :usn
      t.string :location
      t.string :cache_control
      t.string :server
      t.string :ext

      t.timestamps
    end
    add_index :upnps, :st
    add_index :upnps, :usn
    add_index :upnps, :location
    add_index :upnps, :cache_control
    add_index :upnps, :server
    add_index :upnps, :ext
  end
end
