class CreateScanDiffs < ActiveRecord::Migration[5.0]
  def change
    create_table :scan_diffs do |t|
      t.belongs_to :scan, foreign_key: true
      t.belongs_to :device, foreign_key: true
      t.string :kind, null: false
      t.integer :status, null: false
      t.jsonb :extra, null: false, default: {}

      t.timestamps
    end
    add_index :scan_diffs, :kind
    add_index :scan_diffs, :status
    add_index :scan_diffs, :extra, using: :gin
  end
end
