class AddUserToNetwork < ActiveRecord::Migration[5.0]
  def change
    add_reference :networks, :user, foreign_key: true
  end
end
