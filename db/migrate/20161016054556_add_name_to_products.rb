class AddNameToProducts < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :name, :string, null: false
  end
end
