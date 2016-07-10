class PaypalCashout < ActiveRecord::Base
  # Accessible fields
  attr_accessible :transaction_id, :order_id, :status_id, :transaction_amount, :currency, :paid_transaction_amount, :paid_currency, :change_rate, :fee, :order_completed, :user_id, :cashout_account_number

  # Relationships
  belongs_to :user

  # Validations
  validates :transaction_id, :order_id, :status_id, :transaction_amount, :currency, :paid_transaction_amount, :cashout_account_number, presence: true
end
