class RemoveClientIdFromDeliveries < ActiveRecord::Migration[7.1]
  def change
    remove_column :deliveries, :client_id, :integer
  end
end
