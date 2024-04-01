class RemoveClientEmailFromDeliveries < ActiveRecord::Migration[7.1]
  def change
    remove_column :deliveries, :client_email, :string
  end
end
