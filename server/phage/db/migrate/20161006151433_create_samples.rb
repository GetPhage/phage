class CreateSamples < ActiveRecord::Migration[5.0]
  def change
    create_table :samples do |t|

      t.timestamps
    end
  end
end
