class CreatePaymoneyWalletLogs < ActiveRecord::Migration
  def change
    create_table :paymoney_wallet_logs do |t|
      t.string :transaction_type
      t.string :credit_amount
      t.string :checkout_amount
      t.string :otp
      t.string :pin
      t.boolean :status
      t.text :error_log
      t.text :response_log
      t.string :account_number
      t.string :remote_ip_address
      t.string :agent
      t.string :sub_agent
      t.string :transaction_id
      t.integer :user_id

      t.timestamps
    end
  end
end
