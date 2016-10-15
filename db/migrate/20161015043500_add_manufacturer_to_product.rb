class AddManufacturerToProduct < ActiveRecord::Migration[5.0]
  def change
    add_reference :products, :manufacturer, foreign_key: true
  end
end
