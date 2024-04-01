class CreateMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :messages do |t|
      t.references :delivery, null: false, foreign_key: true
      t.references :sender, null: false, foreign_key: { to_table: :users }
      t.references :receiver, null: false, foreign_key: { to_table: :users }
      t.text :content
      t.boolean :delivered, default: false
      t.boolean :received, default: false

      t.timestamps
    end
  end
end
