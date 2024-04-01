class AddUserIdToPackages < ActiveRecord::Migration[7.1]
  def change
    # Create default user if it doesn't exist
    default_user = User.find_or_create_by!(email: 'default@example.com') do |user|
      user.password = 'defaultpassword'
      # set other required fields as necessary
    end

    # Then you can safely use the id
    add_reference :packages, :user, null: false, foreign_key: true, default: default_user.id
  end
end
