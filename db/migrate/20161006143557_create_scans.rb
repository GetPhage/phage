class CreateScans < ActiveRecord::Migration[5.0]
  def change
    create_table :scans do |t|
      t.string :scan_type, null: false
      t.timestamp :start, null: false
      t.timestamp :end, null: false
      t.string :notes, null: false, default: ''

      t.timestamps
    end
    add_index :scans, :scan_type
    add_index :scans, :start
  end
end
