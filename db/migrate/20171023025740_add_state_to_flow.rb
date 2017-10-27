class AddStateToFlow < ActiveRecord::Migration[5.1]
  def change
    add_column :flows, :state, :integer, null: false, default: 1
    add_index :flows, :state
  end
end
