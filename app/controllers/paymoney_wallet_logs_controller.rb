class PaymoneyWalletLogsController < ApplicationController

  layout false

  def store_transaction_log
    PaymoneyWalletLog.create(params)

    render text: "0"
  end

  def store_unlogged_transactions
    status = '0'
    transaction = PaymoneyWalletLog.where("transaction_type = '#{params[:transaction_type]}' AND transaction_id = '#{params[:transaction_id]}'").first rescue nil

    if transaction.blank?
      transaction = PaymoneyWalletLog.new(params)
      if transaction.save
        status = '1'
      end
    else
      status = '1'
    end

    render text: status
  end

end
