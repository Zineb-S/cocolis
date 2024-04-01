class CreateAdminPackages < ActiveRecord::Migration[7.1]
  def change
    create_table :packages do |t|
      t.string :name
      t.text :description
      t.integer :price
      t.references :category, null: false, foreign_key: true
      t.boolean :active
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
