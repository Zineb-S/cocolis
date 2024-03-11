class CreateDeliveryPackages < ActiveRecord::Migration[7.1]
  def change
    create_table :delivery_packages do |t|
      t.references :package, null: false, foreign_key: true
      t.references :delivery, null: false, foreign_key: true
      t.string :departureCity
      t.string :destinationCity
      t.string :departureDate
      t.string :arrivalDate

      t.timestamps
    end
  end
end
