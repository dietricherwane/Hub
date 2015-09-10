class AddGameAccountTokenAndAccountTokenToPaymoneyWalletLogs < ActiveRecord::Migration
  def change
    add_column :paymoney_wallet_logs, :game_account_token, :string
    add_column :paymoney_wallet_logs, :account_token, :string
  end
end
