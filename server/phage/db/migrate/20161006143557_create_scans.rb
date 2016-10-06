class CreateScans < ActiveRecord::Migration[5.0]
  def change
    create_table :scans do |t|
      t.string :scan_type
      t.timestamp :start
      t.timestamp :end
      t.string :notes

      t.timestamps
    end
    add_index :scans, :scan_type
    add_index :scans, :start
  end
end
