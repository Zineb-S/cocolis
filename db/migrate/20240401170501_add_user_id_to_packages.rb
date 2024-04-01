class AddUserIdToPackages < ActiveRecord::Migration[7.1]
  def change
    add_reference :packages, :user, null: true, foreign_key: true
  end


end
