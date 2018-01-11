class AddCashoutAccountNumberToPaypalCashouts < ActiveRecord::Migration
  def change
    add_column :paypal_cashouts, :cashout_account_number, :string
  end
end
