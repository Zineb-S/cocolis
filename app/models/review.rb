class Review < ApplicationRecord
  belongs_to :client, class_name: 'User'
  belongs_to :driver, class_name: 'User'
  belongs_to :delivery

  # Validations
  validates :timeliness, :communication, :handling, presence: true, inclusion: { in: 1..5 }
  validates :comment, length: { maximum: 500 }
end
