class PaypalCashout < ActiveRecord::Base
  # Accessible fields
  attr_accessible :transaction_id, :order_id, :status_id, :transaction_amount, :currency, :paid_transaction_amount, :paid_currency, :change_rate, :fee, :order_completed, :user_id

  # Relationships
  belongs_to :user

  # Validations
  validates :transaction_id, :order_id, :status_id, :transaction_amount, :currency, :paid_transaction_amount, :paid_currency, :change_rate, :fee, presence: true
  validates :transaction_amount, :currency, :paid_transaction_amount, :fee, numericality: true
end
