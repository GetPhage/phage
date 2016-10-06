class CreateSoftwareBlacklists < ActiveRecord::Migration[5.0]
  def change
    create_table :software_blacklists do |t|
      t.string :name
      t.string :version
      t.string :reason

      t.timestamps
    end
    add_index :software_blacklists, :name
    add_index :software_blacklists, :reason
  end
end
