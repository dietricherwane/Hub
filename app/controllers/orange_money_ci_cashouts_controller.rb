class OrangeMoneyCiCashoutsController < ApplicationController
  layout :layout_used

  def save_log
    cashout_log = OrangeMoneyCiCashout.new(params.except(:controller, :action))
    status = "0"

    if cashout_log.save
      status = "1"
    end

    render text: status
  end

  def list
    @cashouts = OrangeMoneyCiCashout.all.order("created_at DESC")
  end

  def validate_cashout
    cashout = OrangeMoneyCiCashout.find_by_transaction_id(params[:transaction_id])

    if cashout.blank?
      flash[:error] = "La transaction n'a pas été trouvée"
    else
      cashout.update_attributes(status_id: '1', user_id: current_user.id, order_completed: true)
      flash[:success] = "La transaction a été validée"
    end

    redirect_to :back
  end

  def cancel_cashout
    cashout = OrangeMoneyCiCashout.find_by_transaction_id(params[:transaction_id])

    if cashout.blank?
      flash[:error] = "La transaction n'a pas été trouvée"
    else
      cashout.update_attributes(status_id: '0', user_id: current_user.id, order_completed: false)
      flash[:success] = "La transaction a été rejetée"
    end

    redirect_to :back
  end
end
