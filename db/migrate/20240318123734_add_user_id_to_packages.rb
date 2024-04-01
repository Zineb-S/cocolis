class AddUserIdToPackages < ActiveRecord::Migration[7.1]
  def change
    add_reference :packages, :user, foreign_key: true, type: :uuid # Adjust :uuid if your IDs are not UUIDs

    if User.exists?
      default_user_id = User.first.id
      # Assuming you want to update all existing records to belong to the first user
      Package.update_all(user_id: default_user_id)
    end
  end


  def default_user_id
    User.first.id
  end

end
