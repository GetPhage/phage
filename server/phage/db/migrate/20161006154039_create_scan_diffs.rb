class CreateScanDiffs < ActiveRecord::Migration[5.0]
  def change
    create_table :scan_diffs do |t|
      t.belongs_to :scan, foreign_key: true
      t.belongs_to :device, foreign_key: true
      t.string :kind
      t.integer :status
      t.jsonb :extra

      t.timestamps
    end
    add_index :scan_diffs, :kind
    add_index :scan_diffs, :status
    add_index :scan_diffs, :extra, using: :gin
  end
end
