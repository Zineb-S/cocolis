class AddDimensionsToPackages < ActiveRecord::Migration[7.1]
  def change
    add_column :packages, :dimensions, :string
  end
end
