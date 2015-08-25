class AddCreatedOnPaymoneyWalletToUsers < ActiveRecord::Migration
  def change
    add_column :users, :created_on_paymoney_wallet, :boolean
  end
end
