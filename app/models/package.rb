class Package < ApplicationRecord
  has_many_attached :images do |attachable|
    attachable.variant :thumb, resize_to_limit: [50,50]
  end
  belongs_to :category
  has_many :delivery_packages
  belongs_to :user
  has_many :deliveries, through: :delivery_packages
  has_many :payments
  accepts_nested_attributes_for :delivery_packages
end
