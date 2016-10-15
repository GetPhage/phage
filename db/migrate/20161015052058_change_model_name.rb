class ChangeModelName < ActiveRecord::Migration[5.0]
  def change
    rename_column :devices, :model_name, :model_shortname
  end
end
