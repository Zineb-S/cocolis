class Message < ApplicationRecord
  belongs_to :delivery
  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'
  belongs_to :delivery_package, optional: true
end
