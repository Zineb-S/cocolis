# app/models/delivery.rb
class Delivery < ApplicationRecord
  belongs_to :driver, class_name: 'User', foreign_key: 'driver_id'

  has_many :delivery_packages, dependent: :destroy
  has_many :reviews
  has_many :payments
  has_many :messages
  has_many :packages, through: :delivery_packages

  accepts_nested_attributes_for :packages
  accepts_nested_attributes_for :delivery_packages
end
