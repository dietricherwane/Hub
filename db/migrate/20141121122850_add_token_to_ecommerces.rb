class AddTokenToEcommerces < ActiveRecord::Migration
  def change
    add_column :ecommerces, :token, :string, limit: 100
  end
end
