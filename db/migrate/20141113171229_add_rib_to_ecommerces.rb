class AddRibToEcommerces < ActiveRecord::Migration
  def change
    add_column :ecommerces, :rib, :string, limit: 100
  end
end
