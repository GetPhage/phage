class CreateHistories < ActiveRecord::Migration[5.0]
  def change
    create_table :histories do |t|
      t.string :message, default: '', null: false
      t.belongs_to :scan_diff, foreign_key: true
      t.belongs_to :user, foreign_key: true

      t.timestamps
    end

    add_index :histories, :message
  end
end
