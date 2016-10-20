class CreateServices < ActiveRecord::Migration[5.0]
  def change
    create_table :services do |t|
      t.string :name, null: false
      t.integer :port_number, null: false
      t.string :protocol, null: false, default: ''
      t.string :description, null: false, default: ''
      t.string :reference, null: false, default: ''

      t.timestamps
    end

    add_index :services, :name
    add_index :services, :port_number
    add_index :services, :protocol
  end
end
