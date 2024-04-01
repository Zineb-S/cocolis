class User < ApplicationRecord
  has_many :packages, dependent: :destroy
  has_many :sent_messages, class_name: 'Message', foreign_key: 'sender_id'
  has_many :received_messages, class_name: 'Message', foreign_key: 'receiver_id'
  # Defines deliveries where the user is the driver
  has_many :driver_deliveries, class_name: 'Delivery', foreign_key: 'driver_id'
  has_many :client_reviews, class_name: 'Review', foreign_key: 'client_id'
  has_many :payments

  # Defines deliveries where the user is the client
  has_many :client_deliveries, class_name: 'Delivery', foreign_key: 'client_id'
  # For clients
  has_many :client_reviews, class_name: 'Review', foreign_key: 'client_id'
  # For drivers
  has_many :driver_reviews, class_name: 'Review', foreign_key: 'driver_id'
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  enum role: { client: 0, driver: 1 }

  # Add validations for new fields as necessary
  validates :first_name, :last_name, :address, :email, :credit_card_info, presence: true
end
