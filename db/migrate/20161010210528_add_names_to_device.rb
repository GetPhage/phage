class AddNamesToDevice < ActiveRecord::Migration[5.0]
  def change
    add_column :devices, :name, :string, array: true, default: []
  end
end
