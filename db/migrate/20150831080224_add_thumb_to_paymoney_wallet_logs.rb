class AddThumbToPaymoneyWalletLogs < ActiveRecord::Migration
  def change
    add_column :paymoney_wallet_logs, :thumb, :float
  end
end
