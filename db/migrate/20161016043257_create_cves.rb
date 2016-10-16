class CreateCves < ActiveRecord::Migration[5.0]
  def change
    create_table :cves do |t|
      t.string :name
      t.string :seq
      t.string :status
      t.string :desc
      t.string :refs
      t.string :comments

      t.timestamps
    end
    add_index :cves, :name
    add_index :cves, :seq
    add_index :cves, :desc
  end
end
