class CreateAdminDeliveries < ActiveRecord::Migration[7.1]
  def change
    create_table :deliveries do |t|
      t.references :client, null: true, foreign_key: { to_table: :users }
      t.references :driver, null: false, foreign_key: { to_table: :users }
      t.boolean :fulfilled
      t.integer :total
      t.string :address

      t.timestamps
    end
  end
end
