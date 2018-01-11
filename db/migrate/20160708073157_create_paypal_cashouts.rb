class CreatePaypalCashouts < ActiveRecord::Migration
  def change
    create_table :paypal_cashouts do |t|
      t.string :transaction_id
      t.string :order_id
      t.string :status_id, limit: 5
      t.string :transaction_amount
      t.string :currency, limit: 5
      t.string :paid_transaction_amount
      t.string :paid_currency
      t.string :change_rate
      t.string :fee
      t.boolean :order_completed
      t.integer :user_id

      t.timestamps
    end
    add_index :paypal_cashouts, :transaction_id
    add_index :paypal_cashouts, :order_id
    add_index :paypal_cashouts, :status_id
  end
end
