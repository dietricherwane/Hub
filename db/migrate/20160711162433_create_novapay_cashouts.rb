class CreateNovapayCashouts < ActiveRecord::Migration
  def change
    create_table :novapay_cashouts do |t|
      t.string :transaction_id
      t.string :order_id
      t.string :status_id
      t.string :transaction_amount
      t.string :currency
      t.string :paid_transaction_amount
      t.string :paid_currency
      t.string :change_rate
      t.string :fee
      t.boolean :order_completed
      t.string :user_id
      t.string :cashout_account_number

      t.timestamps
    end
  end
end
