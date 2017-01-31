class PosAdministrationController < ApplicationController
  before_filter :sign_out_disabled_users

  layout :layout_used

  def list_agents
    @agents = User.where("certified_agent_id IS NOT NULL")
  end

  def list_agent_transactions
    @agent = User.where("certified_agent_id = ? AND status = TRUE", params[:agent_id]) rescue nil
    if @agent.blank?
      redirect_to pos_administration_list_agents_path
    else
      @transactions = PaymoneyWalletLog.where("agent = ? AND status = TRUE", @agent.certified_agent_id).order("created_at DESC")
    end
  end
end
