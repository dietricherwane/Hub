class AddServiceTokenToEcommerces < ActiveRecord::Migration
  def change
    remove_column :ecommerces, :service_toke
    add_column :ecommerces, :service_token, :string, limit: 100
  end
end
