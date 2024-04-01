class AddDeliveryPackageIdToMessages < ActiveRecord::Migration[7.1]
  def change
    add_column :messages, :delivery_package_id, :integer
    add_index :messages, :delivery_package_id
  end
end
