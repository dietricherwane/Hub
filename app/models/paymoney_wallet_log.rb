class PaymoneyWalletLog < ActiveRecord::Base
  # Relationships
  belongs_to :user

  # Set accessible fields
  attr_accessible :transaction_type, :account_number, :credit_amount, :checkout_amount, :fee, :thumb, :otp, :pin, :status, :error_log, :response_log, :remote_ip_address, :agent, :sub_agent, :transaction_id, :game_account_token, :account_token, :mobile_money_account_number, :a_account_transfer, :b_account_transfer

  def self.to_csv
    attributes = %w{Id-de-transaction Type-de-transaction Montant-du-credit Montant-du-debit Montant-des-frais Frais-de-timbre Statut OTP PIN Id-agent-agree Id-sous-agent-agree Date-de-creation}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |transaction|
        csv << [transaction.transaction_id, transaction.transaction_type, transaction.credit_amount, transaction.checkout_amount, transaction.fee, transaction.thumb, (transaction.status == true) ? 'Succes' : 'Echec', transaction.otp, transaction.pin, transaction.agent, transaction.sub_agent, transaction.created_at]
      end
    end
  end
end
