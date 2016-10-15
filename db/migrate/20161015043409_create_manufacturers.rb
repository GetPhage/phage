class CreateManufacturers < ActiveRecord::Migration[5.0]
  def change
    create_table :manufacturers do |t|
      t.string :name
      t.string :web
      t.string :support_url

      t.timestamps
    end
    add_index :manufacturers, :name
  end
end
