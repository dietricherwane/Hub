class AddBancaryFieldsToEcommerces < ActiveRecord::Migration
  def change
    add_column :ecommerces, :bank_code, :string
    add_column :ecommerces, :wicket_code, :string
    add_column :ecommerces, :account_number, :string
  end
end
