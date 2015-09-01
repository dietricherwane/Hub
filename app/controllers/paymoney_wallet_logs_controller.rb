class PaymoneyWalletLogsController < ApplicationController

  layout false

  def store_transaction_log
    PaymoneyWalletLog.create(params)

    render text: "0"
  end

end
