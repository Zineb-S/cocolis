class AddPackageReceivedToDeliveries < ActiveRecord::Migration[7.1]
  def change
    add_column :deliveries, :package_received, :boolean
  end
end
