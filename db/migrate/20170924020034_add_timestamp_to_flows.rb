class AddTimestampToFlows < ActiveRecord::Migration[5.1]
  def change
    add_column :flows, :timestamp, :datetime, null: false
    add_index :flows, :timestamp
  end
end
