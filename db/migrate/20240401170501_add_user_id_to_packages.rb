class AddUserIdToPackages < ActiveRecord::Migration[7.1]
  def change
    # Create default user with all necessary fields filled
    default_user = User.find_or_create_by!(email: 'default@example.com') do |user|
      user.password = 'defaultpassword'
      user.first_name = 'Default'
      user.last_name = 'User'
      user.address = '123 Default St'
      user.credit_card_info = '4111111111111111' # Use a dummy number that passes validation
      # Add any other required fields here
    end

    # Then you can safely use the id
    add_reference :packages, :user, null: false, foreign_key: true, default: default_user.id
  end
end
