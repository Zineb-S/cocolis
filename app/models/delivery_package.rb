class DeliveryPackage < ApplicationRecord
  belongs_to :package
  belongs_to :delivery
  validates :quantity, numericality: { greater_than_or_equal_to: 1 }
  validates :weight, numericality: { greater_than_or_equal_to: 0.0 }
end
