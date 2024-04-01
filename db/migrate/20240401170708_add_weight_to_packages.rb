class AddWeightToPackages < ActiveRecord::Migration[7.1]
  def change
    add_column :packages, :weight, :decimal
  end
end
