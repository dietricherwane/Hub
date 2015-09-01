class AddFeeToPaymoneyWalletLogs < ActiveRecord::Migration
  def change
    add_column :paymoney_wallet_logs, :fee, :float
  end
end
