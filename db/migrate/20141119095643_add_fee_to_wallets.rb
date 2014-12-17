class AddFeeToWallets < ActiveRecord::Migration
  def change
    add_column :wallets, :fee, :float
  end
end
