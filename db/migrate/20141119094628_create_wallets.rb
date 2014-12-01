class CreateWallets < ActiveRecord::Migration
  def change
    create_table :wallets do |t|
      t.string :name, limit: 100
      t.integer :country_id
      t.string :authentication_token, limit: 100

      t.timestamps
    end
  end
end
