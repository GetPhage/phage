class AddOuiToDevice < ActiveRecord::Migration[5.0]
  def change
    add_reference :devices, :oui, foreign_key: true
  end
end
