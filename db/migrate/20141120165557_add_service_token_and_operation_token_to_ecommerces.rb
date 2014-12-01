class AddServiceTokenAndOperationTokenToEcommerces < ActiveRecord::Migration
  def change
    add_column :ecommerces, :service_toke, :string, limit: 100
    add_column :ecommerces, :operation_token, :string, limit: 100
  end
end
