class CreatePayments < ActiveRecord::Migration[7.1]
  def change
    create_table :payments do |t|
      t.integer :delivery_id
      t.integer :delivery_package_id
      t.integer :package_id
      t.integer :client_id
      t.boolean :payment_done

      t.timestamps
    end
  end
end
