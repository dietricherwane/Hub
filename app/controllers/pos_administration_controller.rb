class PosAdministrationController < ApplicationController
  before_filter :sign_out_disabled_users

  layout :layout_used

  def list_agents
    @agents = User.where("certified_agent_id IS NOT NULL AND pos_account_type_id = #{PosAccountType.find_by_name('POS marchand').id}")
  end

  def list_agent_transactions
    @agent = User.where("certified_agent_id = ? AND pos_account_type_id = #{PosAccountType.find_by_name('POS marchand').id}", params[:agent_id]).first rescue nil
    if @agent.blank?
      redirect_to pos_administration_list_agents_path
    else
      @transactions = PaymoneyWalletLog.where("agent = ? AND status = TRUE", @agent.certified_agent_id).order("created_at DESC")
    end
  end
end
