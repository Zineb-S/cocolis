class AddUserIdToPackages < ActiveRecord::Migration[7.1]
  def change
    add_reference :packages, :user, null: false, foreign_key: true, default: default_user_id
  end

  def default_user_id
    User.first.id
  end

end
