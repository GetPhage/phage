class CreateHostnames < ActiveRecord::Migration[5.1]
  def change
    create_table :hostnames do |t|
      t.inet :ipv4, null: false
      t.hstore :names, default: [], array: true
      t.timestamps
    end
    add_index :hostnames, :names
    add_index :hostnames, :ipv4
  end
end
