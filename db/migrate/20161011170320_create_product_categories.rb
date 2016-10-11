class CreateProductCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :product_categories do |t|
      t.string :name
      t.boolean :mobile
      t.belongs_to :product_category, foreign_key: true

      t.timestamps
    end
    add_index :product_categories, :name
    add_index :product_categories, :mobile
  end
end
