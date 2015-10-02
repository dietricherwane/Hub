class PosmController < ApplicationController

  #prepend_before_filter :authenticate_user!#, except: [:get_logo]
  before_filter :sign_out_disabled_users#, except: [:get_logo]

  def index
    @posm_active = "active"
  end

  def transactions_log
    @posm_transactions_active = "active"
    @transactions = PaymoneyWalletLog.where("agent = '#{current_user.certified_agent_id}'")
  end

  def init_form

  end

end
