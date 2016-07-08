class PaypalCashoutsController < ApplicationController
  layout :layout_used

  def save_log
    cashout_log = PaypalCashout.new(params.except(:controller, :action))
    status = "0"

    if cashout_log.save
      status = "1"
    end

    render text: status
  end

  def list
    @cashouts = PaypalCashout.all.order("created_at DESC")
  end

  def validate_cashout
    cashout = PaypalCashout.find_by_transaction_id(params[:transaction_id])

    if cashout.blank?
      flash[:error] = "La transaction n'a pas été trouvée"
    else
      cashout.update_attributes(status_id: '1', user_id: current_user.id, order_completed: true)
      flash[:error] = "La transaction a été validée"
    end

    redirect_to :back
  end

  def cancel_cashout
    cashout = PaypalCashout.find_by_transaction_id(params[:transaction_id])

    if cashout.blank?
      flash[:error] = "La transaction n'a pas été trouvée"
    else
      cashout.update_attributes(status_id: '1', user_id: current_user.id, order_completed: true)
      flash[:error] = "La transaction a été rejetée"
    end

    redirect_to :back
  end

end
