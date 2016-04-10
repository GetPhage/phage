class InitialSetup < ActiveRecord::Migration
  def up
    create_table :devices do |t|
      t.column :mac_address, 'char(6)', null: false
      t.column  :ipv4, 'char(4)', null: true
      t.column :ipv6, 'char(8)', null: true
      t.string :type
      t.timestamp :last_seen

      t.timestamps null: false

      t.index :mac_address
      t.index :ipv4
      t.index :ipv6
      t.index :type
      t.index :last_seen
    end

    create_table :samples do |t|
      t.integer :device_id
      t.column, :mac_address, 'char(6)', null: false
      t.column  :ipv4, 'char(4)', null: true
      t.column :ipv6, 'char(8)', null: true
      t.integer :signal_strength

      t.index :device_id
      t.index :mac_address
      t.index :ipv4
      t.index :ipv6
      t.index :signal_strength

      t.timestamps null: false
    end

    create_table :journal do |t|
      t.integer :device_id
      t.msg :string

      t.timestamps null: false

      t.index :device_id
    end

    create_table :software_versions do |t|
      t.integer :device_id
      t.string :name
      t.string :version

      t.timestamps null: false

      t.index :name
      t.index :version
    end

    create_table :software_blacklist do |t|
      t.string :name
      t.string :version
      t.string :reason

      t.timestamps null: false

      t.index :name
      t.index :version
    end

    add_foreign_key :samples, :devices
    add_foreign_key :software_versions, :devices
  end

  def down
    drop_table :devices
    drop_table :samples
    drop_table :software_versions
    drop_table :software_blacklist
  end
end
