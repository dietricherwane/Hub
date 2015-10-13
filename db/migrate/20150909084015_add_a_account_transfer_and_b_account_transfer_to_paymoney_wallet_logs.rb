class AddAAccountTransferAndBAccountTransferToPaymoneyWalletLogs < ActiveRecord::Migration
  def change
    add_column :paymoney_wallet_logs, :a_account_transfer, :string
    add_column :paymoney_wallet_logs, :b_account_transfer, :string
  end
end
