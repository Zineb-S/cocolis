class AddDefaultToTotalInDeliveries < ActiveRecord::Migration[7.1]
  def change
    change_column :deliveries, :total, :integer, default: 0
  end
end
