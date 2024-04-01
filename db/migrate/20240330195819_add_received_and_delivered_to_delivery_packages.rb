class AddReceivedAndDeliveredToDeliveryPackages < ActiveRecord::Migration[7.1]
  def change
    add_column :delivery_packages, :received, :boolean
    add_column :delivery_packages, :delivered, :boolean
  end
end
