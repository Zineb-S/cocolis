class CreateReviews < ActiveRecord::Migration[7.1]
  def change
    create_table :reviews do |t|
      t.integer :client_id
      t.integer :driver_id
      t.integer :delivery_id
      t.integer :timeliness
      t.integer :communication
      t.integer :handling
      t.text :comment

      t.timestamps
    end
  end
end
