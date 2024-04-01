class Payment < ApplicationRecord
  belongs_to :delivery
  belongs_to :delivery_package
  belongs_to :package
  belongs_to :client, class_name: 'User'

  # Add validations as necessary, for example:
  validates :delivery_id, :delivery_package_id, :package_id, :client_id, presence: true
end
