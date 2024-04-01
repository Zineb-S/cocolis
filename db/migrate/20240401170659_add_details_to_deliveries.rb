class AddDetailsToDeliveries < ActiveRecord::Migration[7.1]
  def change
    add_column :deliveries, :departure_city, :string
    add_column :deliveries, :arrival_city, :string
    add_column :deliveries, :departure_date, :date
    add_column :deliveries, :arrival_date, :date
  end
end
