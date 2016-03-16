class AddPaymoneyAccountNumberToUsers < ActiveRecord::Migration
  def change
    add_column :users, :paymoney_account_number, :string
  end
end
