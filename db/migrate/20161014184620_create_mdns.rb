class CreateMdns < ActiveRecord::Migration[5.0]
  def change
    create_table :mdns do |t|
      t.string :name
      t.string :service
      t.string :protocol
      t.belongs_to :device, foreign_key: true

      t.timestamps
    end
    add_index :mdns, :name
  end
end
