class CreateOuis < ActiveRecord::Migration[5.0]
  def change
    create_table :ouis do |t|
      t.column :prefix, "char(6)", null: false
      t.string :manufacturer, null: false

      t.timestamps
    end
    add_index :ouis, :prefix
    add_index :ouis, :manufacturer
  end
end
