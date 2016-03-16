class PaymoneyWalletLog < ActiveRecord::Base
  # Relationships
  belongs_to :user

  # Set accessible fields
  attr_accessible :transaction_type, :account_number, :credit_amount, :checkout_amount, :fee, :thumb, :otp, :pin, :status, :error_log, :response_log, :remote_ip_address, :agent, :sub_agent, :transaction_id, :game_account_token, :account_token, :mobile_money_account_number, :a_account_transfer, :b_account_transfer
end
