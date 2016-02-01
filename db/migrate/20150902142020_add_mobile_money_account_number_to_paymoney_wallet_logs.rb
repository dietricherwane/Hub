class AddMobileMoneyAccountNumberToPaymoneyWalletLogs < ActiveRecord::Migration
  def change
    add_column :paymoney_wallet_logs, :mobile_money_account_number, :string
  end
end
