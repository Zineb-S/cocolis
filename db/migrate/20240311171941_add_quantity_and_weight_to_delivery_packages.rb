class AddQuantityAndWeightToDeliveryPackages < ActiveRecord::Migration[7.1]
  def change
    add_column :delivery_packages, :quantity, :integer, default: 1, null: false
    add_column :delivery_packages, :weight, :decimal, precision: 10, scale: 2, default: 0.0, null: false
  end
end
