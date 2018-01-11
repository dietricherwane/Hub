class AddPaymoneyFieldsToEcommerces < ActiveRecord::Migration
  def change
    add_column :ecommerces, :created_on_paymoney_wallet, :boolean
    add_column :ecommerces, :paymoney_account_number, :string
    add_column :ecommerces, :paymoney_password, :string
    add_column :ecommerces, :paymoney_token, :string
    add_column :ecommerces, :paymoney_creation_request, :text
    add_column :ecommerces, :paymoney_creation_response, :text
  end
end
