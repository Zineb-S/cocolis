class AddClientAndDriverToDeliveries < ActiveRecord::Migration[7.1]
  def change
    add_reference :deliveries, :driver, null: false, foreign_key: true
    add_reference :deliveries, :client, null: false, foreign_key: true
  end
end
